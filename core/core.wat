(component
  (core module $M
    (func (export "dup") (param i64) (result i64)
      local.get 0
      local.get 0
      i64.add)
  )
  (core instance $m (instantiate $M))

  (func $run (param "a" s64) (result s64)
    (canon lift
      (core func $m "dup"))
  )
  (export "mdup" (func $run))
)
