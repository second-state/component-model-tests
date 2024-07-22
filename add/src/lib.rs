cargo_component_bindings::generate!();

use bindings::exports::component::add::types::{GuestEngine, Operation};

// Internal part
use std::cell::RefCell;

pub struct Engine {
    stack: RefCell<Vec<u32>>,
}

// GuestEngine 是要 export 的 resource Engine 的 trait
impl GuestEngine for Engine {
    fn new() -> Self {
        Engine {
            stack: RefCell::new(vec![]),
        }
    }

    fn push_operand(&self, operand: u32) {
        self.stack.borrow_mut().push(operand);
    }

    fn push_operation(&self, operation: Operation) {
        let mut stack = self.stack.borrow_mut();
        let right = stack.pop().unwrap(); // TODO: error handling!
        let left = stack.pop().unwrap();
        let result = match operation {
            Operation::Add => left + right,
            Operation::Sub => left - right,
        };
        stack.push(result);
    }

    fn execute(&self) -> u32 {
        self.stack.borrow_mut().pop().unwrap() // TODO: error handling!
    }
}
