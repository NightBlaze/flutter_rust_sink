use flutter_rust_bridge::frb;
use super::user_tokes::UserTokens;

#[frb(opaque)]
pub struct User {
    pub id: u64,
    pub tokens: Option<UserTokens>,
}

impl User {
    pub fn new(id: u64) -> User {
        Self {
            id,
            tokens: None,
        }
    }

    async fn is_logged_in(&self) -> bool {
        self.tokens.is_some()
    }
}