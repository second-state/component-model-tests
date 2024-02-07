# core

## commands

```shell
# compile wat to wasm
wasm-tools parse core.wat -o core.wasm
# wrap core module into a component
wasm-tools component new core.wasm -o component.wasm
# extract `*.wit` interface
wasm-tools component wit component.wasm
```
