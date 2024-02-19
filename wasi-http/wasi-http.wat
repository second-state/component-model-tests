(component
  (import "wasi:http")
  (core module $M
    (func (export "run") (result i32)
      i32.const 0)
  )
  (core instance $m (instantiate $M))

  (func $run (result s32)
    (canon lift
      (core func $m "run"))
  )
  (export "run" (func $run))
)
