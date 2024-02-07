(module
  (func (export "dup") (param i32) (result i32)
    local.get 0
    local.get 0
    i32.add))
