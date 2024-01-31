use cancel;
use crate::api::actors::color_box_actor::ColorModel;
use flutter_rust_bridge::frb;
use std::sync::Arc;

#[frb(opaque)]
struct ColorBoxEntity {
    id: u64,
    inner: Arc<tokio::sync::RwLock<ColorBoxInner>>,
}

#[frb(opaque)]
struct ColorBoxInner {
    color: ColorModel,
    color_cancel_token: cancel::Token,
    likes_count: u64,
    is_liked: bool,
}

impl ColorBoxEntity {
    fn new_entity(id: u64) -> ColorBoxEntity {
        Self {
            id,
            inner: Arc::new(tokio::sync::RwLock::new(ColorBoxInner::new_inner())),
        }
    }

    fn start_change_color_entity(&self) {
        let inner = self.inner.clone();
        tokio::spawn(async move {
            let mut inner_locked = inner.write().await;
            if inner_locked.color_cancel_token.is_canceled() {
                inner_locked.color_cancel_token = cancel::Token::new();
                return;
            }
            inner_locked.color = ColorModel::random();
        });
    }

    async fn stop_change_color_entity(&self) {
        let inner_locked = self.inner.read().await;
        inner_locked.color_cancel_token.cancel();
    }

    async fn toggle_like_entity(&self) {
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

// impl Drop for ColorBoxEntity {
//     fn drop(&mut self) {
//         tokio::runtime::Handle::current().block_on(async {
//             self.stop_change_color_entity().await;
//         });
//     }
// }

impl ColorBoxInner {
    fn new_inner() -> ColorBoxInner {
        Self {
            color: ColorModel::random(),
            color_cancel_token: cancel::Token::new(),
            likes_count: 0,
            is_liked: false,
        }
    }
}