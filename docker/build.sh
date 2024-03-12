#!/bin/bash
cmake -Bbuild DCMAKE_BUILD_TYPE=Debug -DWASMEDGE_PLUGIN_WASI_HTTP=ON -DWASMEDGE_BUILD_TOOLS=ON -GNinja .
cmake --build build
