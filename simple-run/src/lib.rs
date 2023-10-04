cargo_component_bindings::generate!();

use bindings::Guest;

struct Component;

impl Guest for Component {
    fn run() -> u32 {
        0
    }
}
