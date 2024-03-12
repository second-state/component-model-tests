#!/bin/bash
WASMEDGE_PLUGIN_PATH=/app/WasmEdge/build/plugins/wasi_http /app/WasmEdge/build/tools/wasmedge/wasmedge --enable-component /app/component-model-tests/http/http.wasm run 0
