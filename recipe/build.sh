#!/bin/bash
set -euo pipefail

mkdir build
cd build

echo "tfel_cmake: ${PREFIX}/share/tfel/cmake"
cmake ${SRC_DIR} \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="${PREFIX}/share/tfel/cmake" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -Denable-c-bindings=OFF \
    -Denable-fortran-bindings=OFF \
    -Denable-python-bindings=ON \
    -Denable-portable-build=ON \
    -Denable-julia-bindings=OFF \
    -Denable-website=OFF \
    -Denable-parallel-stl-algorithms=OFF \
    -DPython_ROOT_DIR:PATH="${PREFIX}" \
    -DPython_FIND_STRATEGY=LOCATION \
    -DPython_FIND_REGISTRY=NEVER \
    -DPython_FIND_FRAMEWORK=NEVER \
    -DUSE_EXTERNAL_COMPILER_FLAGS=ON \
    -DMGIS_APPEND_SUFFIX=OFF \
    -DMGIS_PYTHON_MODULES_INSTALL_DIRECTORY:PATH="${SP_DIR}/mgis"

make -j$CPU_COUNT
make install
