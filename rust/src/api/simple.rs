use std::sync::RwLock;
use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use if_chain::if_chain;

lazy_static! {
    static ref LOGGER_STREAM_SINK: RwLock<Option<StreamSink<String>>> = RwLock::new(None);
}

#[frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(sync)]
pub fn create_log_stream(s: StreamSink<String>) {
    let mut guard = LOGGER_STREAM_SINK.write().unwrap();
    let overriding = guard.is_some();

    *guard = Some(s);

    drop(guard);

    if overriding {
        debug_log(
            "create_log_stream but already exist a sink, thus overriding. \
            (This may or may not be a problem. It will happen normally if hot-reload Flutter app.)".to_string()
        );
    }
}

#[frb(ignore)]
pub fn debug_log(message: String) {
    if_chain! {
        if let Ok(sink) = LOGGER_STREAM_SINK.read();
        if let Some(sink) = sink.as_ref();
        then {
            let _ = sink.add(format!{"engine: {message}"});
        }
    }
}