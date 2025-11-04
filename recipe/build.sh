#!/bin/bash
set -euo pipefail

mkdir build
cd build

cmake ${SRC_DIR} \
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
    -DPython_ROOT_DIR:PATH="${PREFIX}" \
    -DPython_FIND_STRATEGY=LOCATION \
    -DPython_FIND_REGISTRY=NEVER \
    -DPython_FIND_FRAMEWORK=NEVER \
    -DUSE_EXTERNAL_COMPILER_FLAGS=ON \
    -DMGIS_APPEND_SUFFIX=OFF \
    -DMGIS_PYTHON_MODULES_INSTALL_DIRECTORY:PATH="${SP_DIR}/mgis" \
    -DSITE_PACKAGES_DIR:PATH="${SP_DIR}" \
    ${CMAKE_ARGS}

make -j$CPU_COUNT
make install
