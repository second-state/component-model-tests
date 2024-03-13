# http

## commands

```shell
# compile wat to wasm
wasm-tools parse http.wat -o http.wasm
```
 
## Explanation

```wasm
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
```

The file defines a component, where have

1. Imports a component `wasi:http/test`, such that have two functions
2. Lowering two functions
3. A core module `M`
4. Instantiate the core module `M`, named instance `main`, with two lowering functions as immediate core instance
3. Canonical lift a core function `run` from instance `main` to be a component function
4. Export the component function

When one executes the component (refers [docker](../docker#run-the-wasi-http-demo), result `run x` is do http get to URL index at `x`, and print the content.
