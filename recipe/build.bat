@echo on
cmake -S . -B build -G Ninja %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DBUILD_TESTING=ON
if errorlevel 1 exit /b 1
cmake --build build --parallel %CPU_COUNT%
if errorlevel 1 exit /b 1
ctest --test-dir build --output-on-failure
if errorlevel 1 exit /b 1
cmake --install build
if errorlevel 1 exit /b 1
