(component
  (type (;0;)
    (instance
      (type (;0;) (tuple string string))
      (type (;1;) (list 0))
      (export (;0;) "get-environment" (func (result 1)))
    )
  )
  (import "wasi:cli/environment@0.2.0-rc-2023-12-05" (instance (;0;) (type 0)))
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
