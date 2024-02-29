(component
  (import "http" (instance $http
    (export "http-get" (func (param "index" s64) (result string)))
    (export "print" (func (param "text" string)))
  ))

  (core func $http-get (canon lower
    (func $http "http-get")
  ))
  (core func $print (canon lower
    (func $http "print")
  ))

  (core module $M
    (func (import "http" "http-get") (param i64) (result i32 i32))
    (func (import "http" "print") (param i32 i32))

    (func (export "run") (param i32) (result i32)
      local.get 0
      )
  )

  (core instance $m
    (instantiate $M
      (with "http"
        (instance
          (export "http-get" (func $http-get))
          (export "print" (func $print))
        )
      )
    )
  )

  (func $run (param "a" s32) (result s32)
    (canon lift
      (core func $m "dup"))
  )
  (export "mdup" (func $run))
)
