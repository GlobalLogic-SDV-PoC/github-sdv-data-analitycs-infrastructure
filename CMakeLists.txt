cmake_minimum_required(VERSION 3.16.3)
project(
    aws_iot_bridge_app
    LANGUAGES CXX
    VERSION 1.0.0)

add_subdirectory(dep/internal/aws_iot)

add_executable(${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE aws_iot_bridge_core)
target_include_directories(${PROJECT_NAME} PRIVATE include)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
