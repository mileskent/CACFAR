cmake_minimum_required(VERSION 4.0)
project(cacfar LANGUAGES CXX HIP)

if(NOT DEFINED CMAKE_HIP_ARCHITECTURES)
    set(CMAKE_HIP_ARCHITECTURES native)
endif()
message(STATUS "HIP Architecture: ${CMAKE_HIP_ARCHITECTURES}")

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.cc" "kernels/*.hip")
add_executable(${PROJECT_NAME} ${SOURCES})

target_compile_options(${PROJECT_NAME} PRIVATE
    "$<$<COMPILE_LANGUAGE:CXX>:-Wall;-Wextra;-Wpedantic;-Werror>"
    "$<$<COMPILE_LANGUAGE:HIP>:-Werror;all-warnings>"
)

add_custom_target(run
    COMMAND ${CMAKE_BINARY_DIR}/${PROJECT_NAME}
    DEPENDS ${PROJECT_NAME}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Launching executable..."
)
