# component model tests

The component model test suites for wasmedge development.

## Prepare WasmEdge and test

1. build latest wasmedge from source
2. `cd simple-run && cargo component build`
3. run `wasmedge --enable-component simple-run/target/wasm32-wasi/debug/simple_run.wasm`

## Build command

```shell
cargo component build
```
