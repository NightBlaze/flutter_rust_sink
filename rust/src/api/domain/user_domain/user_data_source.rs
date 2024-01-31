use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use std::sync::Arc;
use super::user::User;

lazy_static! {
    static ref USER_DATA_SOURCE: Arc<tokio::sync::RwLock<UserDataSource>> = Arc::new(tokio::sync::RwLock::new(UserDataSource::new()));
}

#[frb(opaque)]
struct UserDataSource {
    user: User,
}

impl UserDataSource {
    fn new() -> UserDataSource {
        Self { user: User::new(0) }
    }
}