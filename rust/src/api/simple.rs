use cancel::{Canceled, Token};
use core::time;
use crate::frb_generated::{StreamSink, FLUTTER_RUST_BRIDGE_HANDLER};
use flutter_rust_bridge::{frb, transfer, DartFnFuture};
use lazy_static::lazy_static;
use rand::Rng;
use std::{sync::Mutex, thread};

lazy_static!{
    static ref COLOR_SINK_CANCEL: Mutex<Option<Token>> = Mutex::new(None);
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

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

pub fn get_random_color_async() -> ColorModel {
    ColorModel::random()
}

#[frb(sync)]
pub fn get_random_color_sync() -> ColorModel {
    ColorModel::random()
}

pub async fn get_random_color_callback(dart_callback: impl Fn(ColorModel) -> DartFnFuture<()>) {
    dart_callback(ColorModel::random()).await;
}

pub fn get_random_color_sink(sink: StreamSink<ColorModel>) {
    {
        let mut token = COLOR_SINK_CANCEL.lock().unwrap();
        *token = Some(Token::new());
    }
    FLUTTER_RUST_BRIDGE_HANDLER.thread_pool().0.execute(
        transfer!(|| {
            loop {
                let token = COLOR_SINK_CANCEL.lock().unwrap();
                if token.as_ref().unwrap().is_canceled() {
                    return;
                }
                sink.add(ColorModel::random()).unwrap();
                thread::sleep(time::Duration::from_millis(1500));
            };
        })
    );
}

#[frb(sync)]
pub fn cancel_get_random_color_sink() {
    let token = COLOR_SINK_CANCEL.lock().unwrap();
    token.as_ref().unwrap().cancel();
}