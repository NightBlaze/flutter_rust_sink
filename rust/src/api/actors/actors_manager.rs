use lazy_static::lazy_static;
use std::sync::atomic::AtomicU64;

lazy_static! {
    static ref ACTORS_IDS_GENERATOR: AtomicU64 = AtomicU64::new(1);
}

#[flutter_rust_bridge::frb(sync)]
pub fn generate_actor_id() -> u64 {
    ACTORS_IDS_GENERATOR.fetch_add(1, std::sync::atomic::Ordering::SeqCst) as u64
}
