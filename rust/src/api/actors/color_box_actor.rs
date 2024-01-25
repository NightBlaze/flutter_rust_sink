use cancel::Token;
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use rand::Rng;
use std::{collections::HashMap, io::Write, sync::Arc};

lazy_static! {
    static ref COLOR_BOX_ACTOR_HANDLES: Arc<tokio::sync::RwLock<HashMap<u64, ColorBoxActorHandle>>>  = Arc::new(tokio::sync::RwLock::new(HashMap::new()));
}

#[derive(Debug, Clone, Copy)]
pub struct ColorModel {
    pub red: u8,
    pub green: u8,
    pub blue: u8
}

impl ColorModel {
    fn new(red: u8, green: u8, blue: u8) -> ColorModel {
        ColorModel { red, green, blue }
    }

    fn random() -> ColorModel {
        ColorModel::new(rand::thread_rng().gen(), rand::thread_rng().gen(), rand::thread_rng().gen())
    }

    #[frb(sync)]
    pub fn description(&self) -> String {
        format!("red: {}, gree: {}, blue: {}", self.red, self.green, self.blue)
    }
}

enum ColorBoxActorMessage {
    ChangeColor {
        respond_to: tokio::sync::oneshot::Sender<Option<ColorModel>>,
    },
    ChangeColorSink {
        sink: StreamSink<ColorModel>,
    },
    CancelChangeColorSink,
    Like {
        respond_to: tokio::sync::oneshot::Sender<Option<String>>,
    },
}


pub async fn color_box_new(actor_id: u64) {
    ColorBoxActorHandle::new(actor_id).await;
}

pub async fn color_box_delete(actor_id: u64) {
    let mut actors = COLOR_BOX_ACTOR_HANDLES.write().await;
    actors.remove(&actor_id);
}

pub async fn color_box_change_color(actor_id: u64) -> Option<ColorModel> {
    let actors = COLOR_BOX_ACTOR_HANDLES.read().await;
    let actor = actors.get(&actor_id);
    match actor {
        Some(actor) => actor.change_color().await,
        None => None,
    }
}

pub async fn color_box_change_color_sink(actor_id: u64, sink: StreamSink<ColorModel>) {
    let actors = COLOR_BOX_ACTOR_HANDLES.read().await;
    let actor = actors.get(&actor_id);
    match actor {
        Some(actor) => actor.change_color_sink(sink).await,
        None => {},
    }
}

pub async fn color_box_cancel_change_color_sink(actor_id: u64) {
    let actors = COLOR_BOX_ACTOR_HANDLES.read().await;
    let actor = actors.get(&actor_id);
    match actor {
        Some(actor) => actor.cancel_change_color_sink().await,
        None => {},
    }
}

pub async fn color_box_like(actor_id: u64) -> Option<String> {
    let actors = COLOR_BOX_ACTOR_HANDLES.read().await;
    let actor = actors.get(&actor_id);
    match actor {
        Some(actor) => actor.like().await,
        None => None,
    }
}

struct ColorBoxActorHandle {
    id: u64,
    sender: tokio::sync::mpsc::Sender<ColorBoxActorMessage>,
}

impl ColorBoxActorHandle {
    async fn new(id: u64) {
        let (sender, receiver) = tokio::sync::mpsc::channel(1);
        let actor = ColorBoxActor::new(id, receiver);
        tokio::spawn(ColorBoxActor::run(actor));

        let color_box_actor_handle = Self { id, sender };
        let mut color_box_actors = COLOR_BOX_ACTOR_HANDLES.write().await;
        color_box_actors.insert(id, color_box_actor_handle);
        println!("😄 color box actors count {:?}", color_box_actors.len());
    }

    async fn change_color(&self) -> Option<ColorModel> {
        let (response_sender, response_receiver) = tokio::sync::oneshot::channel();
        let msg = ColorBoxActorMessage::ChangeColor {
            respond_to: response_sender
        };

        // Ignore send errors. If this send fails, so does the
        // recv.await below. There's no reason to check for the
        // same failure twice.
        // println!("will send message to actor. request_id: {:?}", request_id);
        let _ = self.sender.send(msg).await;
        // println!("sent message to actor. request_id: {:?}", request_id);
        // TODO: unwrap
        let result = response_receiver.await.unwrap();
        // println!("got message from actor. request_id: {:?}", request_id);
        result
    }

    async fn change_color_sink(&self, sink: StreamSink<ColorModel>) {
        let msg = ColorBoxActorMessage::ChangeColorSink { sink };

        // Ignore send errors. If this send fails, so does the
        // recv.await below. There's no reason to check for the
        // same failure twice.
        // println!("will send message to actor. request_id: {:?}", request_id);
        let _ = self.sender.send(msg).await;
    }

    async fn cancel_change_color_sink(&self) {
        let msg = ColorBoxActorMessage::CancelChangeColorSink;

        // Ignore send errors. If this send fails, so does the
        // recv.await below. There's no reason to check for the
        // same failure twice.
        // println!("will send message to actor. request_id: {:?}", request_id);
        let _ = self.sender.send(msg).await;
    }

    async fn like(&self) -> Option<String> {
        let (response_sender, response_receiver) = tokio::sync::oneshot::channel();
        let msg = ColorBoxActorMessage::Like {
            respond_to: response_sender
        };

        // Ignore send errors. If this send fails, so does the
        // recv.await below. There's no reason to check for the
        // same failure twice.
        // println!("will send message to actor. request_id: {:?}", request_id);
        let _ = self.sender.send(msg).await;
        // println!("sent message to actor. request_id: {:?}", request_id);
        // TODO: unwrap
        let result = response_receiver.await.unwrap();
        // println!("got message from actor. request_id: {:?}", request_id);
        result
    }
}

struct ColorBoxActor {
    id: u64,
    receiver: tokio::sync::mpsc::Receiver<ColorBoxActorMessage>,
    inner: ColorBoxActorInner,
}

impl ColorBoxActor {
    fn new(id: u64, receiver: tokio::sync::mpsc::Receiver<ColorBoxActorMessage>) -> Self {
        ColorBoxActor {
            id,
            receiver,
            inner: ColorBoxActorInner::new(id),
        }
    }

    async fn run(mut actor: ColorBoxActor) {
        while let Some(msg) = actor.receiver.recv().await {
            let mut inner = actor.inner.clone();
            tokio::spawn(async move {
                inner.handle_message(msg).await;
            });
        }
    }
}

#[derive(Clone)]
struct ColorBoxActorInner {
    id: u64,
    color_sink_cancel: Arc<tokio::sync::RwLock<Option<Token>>>,
    likes_count: Arc<tokio::sync::RwLock<u64>>,
    color: Arc<tokio::sync::RwLock<ColorModel>>,
    is_liked: Arc<tokio::sync::RwLock<bool>>,
}

impl ColorBoxActorInner {
    fn new(actor_id: u64) -> ColorBoxActorInner {
        ColorBoxActorInner {
            id: actor_id,
            color_sink_cancel: Arc::new(tokio::sync::RwLock::new(None)),
            likes_count: Arc::new(tokio::sync::RwLock::new(0)),
            color: Arc::new(tokio::sync::RwLock::new(ColorModel::new(0, 128, 0))),
            is_liked: Arc::new(tokio::sync::RwLock::new(false)),
        }
    }

    async fn handle_message(&mut self, msg: ColorBoxActorMessage) {
        match msg {
            ColorBoxActorMessage::ChangeColor { respond_to } => {
                let color = self.change_color().await;

                // The `let _ =` ignores any errors when sending.
                //
                // This can happen if the `select!` macro is used
                // to cancel waiting for the response.
                let _ = respond_to.send(Some(color));
            },
            ColorBoxActorMessage::ChangeColorSink { sink } => {
                self.change_color_sink(sink).await;
            }
            ColorBoxActorMessage::CancelChangeColorSink => {
                self.cancel_change_color_sink().await;
            },
            ColorBoxActorMessage::Like {  respond_to } => {
                let count = self.like().await;
                let _ = respond_to.send(Some(count));
            },
        }
    }

    async fn change_color(&self) -> ColorModel {
        let mut color = self.color.write().await;
        *color = ColorModel::random();
        *color
    }

    async fn change_color_sink(&self, sink: StreamSink<ColorModel>) {
        {
            let mut token = self.color_sink_cancel.write().await;
            *token = Some(Token::new());
        }
        loop {
            let token = self.color_sink_cancel.read().await;
            if token.as_ref().unwrap().is_canceled() {
                return;
            }
            sink.add(ColorModel::random()).unwrap();
            println!("😄 change_color_sink");
            tokio::time::sleep(tokio::time::Duration::from_millis(1500)).await;
        };
    }
    
    async fn cancel_change_color_sink(&self) {
        let token = self.color_sink_cancel.read().await;
        token.as_ref().unwrap().cancel();
    }

    async fn like(&self) -> String {
        let mut likes_count = self.likes_count.write().await;
        let mut is_liked = self.is_liked.write().await;
        if *is_liked {
            *likes_count -= 1;
            *is_liked = false;
        } else {
            *likes_count += 1;
            *is_liked = true;
        }
        (*likes_count).to_string()
    }
}