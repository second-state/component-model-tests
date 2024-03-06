(component
  (import "wasi:http/test" (instance $http
    (export "http-get" (func (param "index" u64) (result string)))
    (export "print" (func (param "text" string)))
  ))

  (core func $http-get (canon lower
    (func $http "http-get")
  ))
  (core func $print (canon lower
    (func $http "print")
  ))

  (core module $M
    (func $g (import "http" "http-get") (param i64) (result i64 i64))
    (func $p (import "http" "print") (param i64 i64))

    (func (export "run") (param i64)
      local.get 0
      call $g
      call $p
      )
  )

  (core instance $main
    (instantiate $M
      (with "http"
        (instance
          (export "http-get" (func $http-get))
          (export "print" (func $print))
        )
      )
    )
  )

  (func $run (param "a" u64)
    (canon lift
      (core func $main "run"))
  )
  (export "run" (func $run))
)
