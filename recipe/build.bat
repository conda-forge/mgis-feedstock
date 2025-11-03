@echo off
setlocal ENABLEDELAYEDEXPANSION

set CLICOLOR_FORCE=1

rem Clean PY_VER by removing dots (e.g., 3.12 -> 312) for library paths
set "PY_VER_CLEAN=%PY_VER:.=%"

rem Set TFELHOME to the PREFIX environment variable
set TFELHOME=%PREFIX%
set FC=flang-new

rem Normalize SP_DIR to forward slashes for CMake
set "SP_DIR_FWD=%SP_DIR:\=/%"

rem Prepare a clean build dir at %RB_SRC_DIR%\build to avoid CMake cache/source mismatches
set "BUILD_DIR=%RB_SRC_DIR%\build"
if exist "%BUILD_DIR%" (
  echo Removing existing build directory to avoid stale CMake cache: "%BUILD_DIR%"
  rmdir /s /q "%BUILD_DIR%"
)
mkdir "%BUILD_DIR%"
rem ------------------------------------------------------------

cmake -B "%BUILD_DIR%" -G "Ninja" ^
    %CMAKE_ARGS% ^
    -DCMAKE_BUILD_TYPE=%build_type% ^
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
    -Denable-c-bindings=ON ^
    -Denable-fortran-bindings=ON ^
    -Denable-python-bindings=ON ^
    -Denable-portable-build=ON ^
    -Denable-julia-bindings=OFF ^
    -Denable-website=OFF ^
    -Denable-broken-boost-python-module-visibility-handling=ON ^
    -DPYTHONLIBS_VERSION_STRING="%PY_VER%" ^
    -DPython_ADDITIONAL_VERSIONS="%python_version%" ^
    -DPYTHON_EXECUTABLE:FILEPATH="%PREFIX%/python.exe" ^
    -DPYTHON_LIBRARY:FILEPATH=%PREFIX%\libs\python%PY_VER_CLEAN%.lib ^
    -DPYTHON_LIBRARY_PATH:PATH="%PREFIX%/libs" ^
    -DPYTHON_INCLUDE_DIRS:PATH="%PREFIX%/include" ^
    -DPYTHON_INCLUDE_DIR:PATH="%PREFIX%/include" ^
    -DPython_ROOT_DIR:PATH="%PREFIX%" ^
    -DPython_FIND_STRATEGY=LOCATION ^
    -DUSE_EXTERNAL_COMPILER_FLAGS=ON ^
    -DMGIS_APPEND_SUFFIX=OFF ^
    -DMGIS_PYTHON_MODULES_INSTALL_DIRECTORY:PATH="%SP_DIR_FWD%/mgis" ^
    -DSITE_PACKAGES_DIR:PATH="%SP_DIR_FWD%"

if errorlevel 1 (
    echo CMake configuration failed!
    if exist "%BUILD_DIR%\CMakeFiles\CMakeError.log" (
        echo --- CMakeError.log ---
        type "%BUILD_DIR%\CMakeFiles\CMakeError.log"
        echo --- end CMakeError.log ---
    )
    if exist "%BUILD_DIR%\CMakeFiles\CMakeOutput.log" (
        echo --- CMakeOutput.log ---
        type "%BUILD_DIR%\CMakeFiles\CMakeOutput.log"
        echo --- end CMakeOutput.log ---
    )
    exit /b 1
)

cmake --build "%BUILD_DIR%" --target install

IF ERRORLEVEL 1 (
  type configure.log
  exit /b 1
)
endlocal
