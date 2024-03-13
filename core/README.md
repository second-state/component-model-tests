# core

## commands

The following command show how we produce the files in this directory.

```shell
# compile wat to wasm
wasm-tools parse core.wat -o core.wasm
```

## Explanation

```wasm
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
```

The file defines a component, where have

1. A core module `M`
2. Instantiate the core module `M`, named instance `m`
3. Canonical lift a core function `dup` from instance `m` to be a component function
4. Export the component function

When one executes the component (refers [docker](../docker#run-the-core-component-model-demo), result `mdup x = 2 * x`.
