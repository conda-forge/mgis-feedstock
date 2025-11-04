#!/bin/bash
set -euo pipefail

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -Denable-c-bindings=OFF \
    -Denable-fortran-bindings=OFF \
    -Denable-python-bindings=ON \
    -Denable-portable-build=ON \
    -Denable-julia-bindings=OFF \
    -Denable-website=OFF \
    -Denable-broken-boost-python-module-visibility-handling=ON \
    -DPYTHONLIBS_VERSION_STRING="${PY_VER}" \
    -DPython_ADDITIONAL_VERSIONS="${PY_VER}" \
    -DPYTHON_EXECUTABLE:FILEPATH="${PREFIX}/bin/python" \
    -DPYTHON_LIBRARY:FILEPATH="${PREFIX}/lib/libpython${PY_VER}.so" \
    -DPYTHON_LIBRARY_PATH:PATH="${PREFIX}/lib" \
    -DPYTHON_INCLUDE_DIRS:PATH="${PREFIX}/include" \
    -DUSE_EXTERNAL_COMPILER_FLAGS=ON \
    ${CMAKE_ARGS}

make -j$CPU_COUNT
make install
