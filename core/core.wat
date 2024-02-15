(component
  (core module $M
    (func (export "dup") (param i32) (result i32)
      local.get 0
      local.get 0
      i32.add)
  )
  (core instance $m (instantiate $M))

  (func $run (param "a" s32) (result s32)
    (canon lift
      (core func $m "dup"))
  )
  (export "mdup" (func $run))
)
