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
