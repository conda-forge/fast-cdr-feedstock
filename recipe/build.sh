#!/bin/bash
set -euxo pipefail
export CMAKE_GENERATOR=Ninja

cmake -S . -B build -G Ninja ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_TESTING=ON
cmake --build build --parallel "$CPU_COUNT"
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" != "1" ]]; then
    ctest --test-dir build --output-on-failure
fi
cmake --install build
