FROM wasmedge/wasmedge:ubuntu-build-clang

WORKDIR /app

RUN apt update && apt install -y libssl-dev
RUN git clone --branch component-model/instantiate https://github.com/WasmEdge/WasmEdge.git
RUN git clone https://github.com/second-state/component-model-tests.git

COPY ./build.sh /app/WasmEdge
COPY ./run-core.sh /app
COPY ./run-wasi-http.sh /app

WORKDIR /app/WasmEdge
RUN ./build.sh

WORKDIR /app
RUN ./run-core.sh
RUN ./run-wasi-http.sh

ENTRYPOINT ["/bin/bash"]
