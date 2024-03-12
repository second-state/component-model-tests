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

1. At [http](http/) example, the import statement is actually importing a core module, not a component. This is because we haven't let WasmEdge plugin produces a component instance, we have some workarounds here. This leads some problems
    1. canonical ABI part has no effect
    2. plugin cannot export proper types
2. The validation of component is incomplete, there is no guarantee your program with problems can be detected.

## Next step

1. We are going to implement canonical ABI first, this will need data conversion which rely on `memory` and `reallocate` options in canonical lift/lowering.
2. Implement validation about types.
3. Let WasmEdge plugin produces component instance, then we can start implementing preview2.
