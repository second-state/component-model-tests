# component model tests

The component model test suites for wasmedge development.

## Build WasmEdge with plugin

```shell
cd /path/to/wasmedge
mkdir build; cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DWASMEDGE_PLUGIN_WASI_HTTP=ON -DWASMEDGE_BUILD_TOOLS=ON -GNinja ..
ninja
```

## Run example

```shell
# at /path/to/wasmedge/build
./tools/wasmedge/wasmedge --enable-component /path/to/component-model-tests/core/core.wasm mdup 100

WASMEDGE_PLUGIN_PATH=./plugins/wasi_http ./tools/wasmedge/wasmedge --enable-component \
  /path/to/component-model-tests/http/http.wasm run 0
```

## Limitation

1. canonical ABI haven't get implemented
2. plugin cannot export proper types yet
2. The validation of component is incomplete, there is no guarantee your program with problems can be detected.

## Next step

- [x] Let WasmEdge plugin produces component instance.
- [ ] We are going to implement canonical ABI first, this will need data conversion which rely on `memory` and `reallocate` options in canonical lift/lowering.
- [ ] implements resource
- [ ] wasi preview2
- [ ] Implement validation about types.
