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
  /path/to/component-model-tests/http/http.wasm run "https://google.com"
```

## Limitation

The validation of component is incomplete, there is no guarantee your program with problems can be detected.
  - we only do validation for nested module.
  - new concepts in components not checked yet.

## Next step

- [x] Let WasmEdge plugin produces component instance.
- [x] We are going to implement canonical ABI first, this will need data conversion which rely on `memory` and `reallocate` options in canonical lift/lowering.
    - [x] rely on shared `memory`
    - [x] rely on `reallocate` function
- [x] implements canonical resource
- [ ] wasi preview2
- [ ] Implement validation about types.
