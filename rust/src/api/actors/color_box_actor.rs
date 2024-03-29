use crate::{api::simple::debug_log, frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER}};
use flutter_rust_bridge::{frb, spawn, spawn_blocking_with, DartFnFuture};
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

#[derive(Clone)]
#[frb(opaque)]
pub struct ColorBoxActor {
    id: u64,
    inner: Arc<tokio::sync::RwLock<ColorBoxActorInner>>,
}

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
        debug_log("😄 set_color_sink 1".to_string());
        let mut inner_locked = self.inner.write().await;
        inner_locked.color_sink = Some(color_sink);
        debug_log("😄 set_color_sink 2".to_string());
    }

    pub async fn dispose(&self) {
        debug_log("😄 dispose 1".to_string());
        let mut inner_locked = self.inner.write().await;
        inner_locked.color_cancel_token.cancel();
        inner_locked.color_sink = None;
        debug_log("😄 dispose 2".to_string());
    }

    #[frb(sync)] 
    pub fn change_color(&self) -> ColorModel {
        ColorModel::random()
    }

    pub async fn start_change_color(&self) {
        let inner = self.inner.clone();
        let _ = spawn(async move {
            loop {
                let mut inner_locked = inner.write().await;
                // inner_locked.start_change_color_inner();
                if inner_locked.color_cancel_token.is_canceled() {
                    inner_locked.color_cancel_token = cancel::Token::new();
                    return;
                }
                inner_locked.color = ColorModel::random();
                inner_locked.color_sink.as_ref().unwrap().add(inner_locked.color).unwrap();
                drop(inner_locked);
                tokio::time::sleep(tokio::time::Duration::from_millis(1500)).await;
            }
        }).await;
    }

    pub async fn stop_change_color(&self) {
        debug_log("😄 stop_change_color 1".to_string());
        let inner_locked = self.inner.read().await;
        inner_locked.color_cancel_token.cancel();
        debug_log("😄 stop_change_color 2".to_string());
    }

    pub async fn toggle_like(&self) {
        let inner = self.inner.clone();
        let _ = spawn(async move {
            let mut inner_locked = inner.write().await;
            if inner_locked.is_liked {
                inner_locked.likes_count -= 1;
                inner_locked.is_liked = false;
            } else {
                inner_locked.likes_count += 1;
                inner_locked.is_liked = true;
            }
        }).await;
    }
}

impl Drop for ColorBoxActor {
    fn drop(&mut self) {
        debug_log("😄 drop colorBoxActor".to_string());
        // let cloned = self.clone();
        // spawn_blocking_with(|| async move {
        //     cloned.stop_change_color().await;
        // }, FLUTTER_RUST_BRIDGE_HANDLER.thread_pool());
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

impl Drop for ColorBoxActorInner {
    fn drop(&mut self) {
        debug_log("😄 drop colorBoxActorInner".to_string());
    }
}