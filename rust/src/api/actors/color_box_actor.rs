use crate::frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER};
use flutter_rust_bridge::{frb, spawn_blocking_with, DartFnFuture};
use lazy_static::lazy_static;
use rand::Rng;
use std::{collections::HashMap, io::Write, sync::Arc};
use super::actors_manager::generate_actor_id;

// lazy_static! {
//     static ref COLOR_BOX_ACTORS: Arc<tokio::sync::RwLock<HashMap<u64, ColorBoxActor>>>  = Arc::new(tokio::sync::RwLock::new(HashMap::new()));
// }

#[derive(Debug, Clone, Copy)]
pub struct ColorModel {
    pub red: u8,
    pub green: u8,
    pub blue: u8
}

impl ColorModel {
    pub fn new(red: u8, green: u8, blue: u8) -> ColorModel {
        ColorModel { red, green, blue }
    }

    pub fn random() -> ColorModel {
        ColorModel::new(rand::thread_rng().gen(), rand::thread_rng().gen(), rand::thread_rng().gen())
    }

    #[frb(sync)]
    pub fn description(&self) -> String {
        format!("red: {}, gree: {}, blue: {}", self.red, self.green, self.blue)
    }
}

#[frb(opaque)]
pub struct ColorBoxActor {
    id: u64,
    inner: Arc<tokio::sync::RwLock<ColorBoxActorInner>>,
}

// #[frb(opaque)]
struct ColorBoxActorInner {
    color: ColorModel,
    color_cancel_token: cancel::Token,
    color_sink: Option<StreamSink<ColorModel>>,
    likes_count: u64,
    is_liked: bool,
}

impl ColorBoxActor {
    #[frb(sync)]
    pub fn new() -> ColorBoxActor {
        ColorBoxActor {
            id: generate_actor_id(),
            inner: Arc::new(tokio::sync::RwLock::new(ColorBoxActorInner::new())),
        }
    }

    pub async fn set_color_sink(&self, color_sink: StreamSink<ColorModel>) {
        let mut inner_locked = self.inner.write().await;
        inner_locked.color_sink = Some(color_sink);
    }

    #[frb(sync)] 
    pub fn change_color(&self) -> ColorModel {
        ColorModel::random()
    }

    #[frb(sync)]
    pub fn start_change_color(&self) {
        let inner = self.inner.clone();
        tokio::spawn(async move {
            let mut inner_locked = inner.write().await;
            // inner_locked.start_change_color_inner();
            if inner_locked.color_cancel_token.is_canceled() {
                inner_locked.color_cancel_token = cancel::Token::new();
                return;
            }
            inner_locked.color = ColorModel::random();
            inner_locked.color_sink.as_ref().unwrap().add(inner_locked.color).unwrap();
            tokio::time::sleep(tokio::time::Duration::from_millis(1500)).await;
        });
    }

    pub async fn stop_change_color(&self) {
        let inner_locked = self.inner.read().await;
        inner_locked.color_cancel_token.cancel();
    }

    #[frb(sync)]
    pub fn toggle_like(&self) {
        let inner = self.inner.clone();
        tokio::spawn(async move {
            let mut inner_locked = inner.write().await;
            if inner_locked.is_liked {
                inner_locked.likes_count -= 1;
                inner_locked.is_liked = false;
            } else {
                inner_locked.likes_count += 1;
                inner_locked.is_liked = true;
            }
        });
    }
}

impl Drop for ColorBoxActor {
    fn drop(&mut self) {
        tokio::runtime::Handle::current().block_on(async {
            self.stop_change_color().await;
        });
    }
}

impl ColorBoxActorInner {
    fn new() -> ColorBoxActorInner {
        ColorBoxActorInner {
            color: ColorModel::random(),
            color_cancel_token: cancel::Token::new(),
            color_sink: None,
            likes_count: 0,
            is_liked: false,
        }
    }

    fn start_change_color_inner(&mut self) {
        if self.color_cancel_token.is_canceled() {
            self.color_cancel_token = cancel::Token::new();
            return;
        }
        self.color = ColorModel::random();
    }
}