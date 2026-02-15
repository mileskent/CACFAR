cmake_minimum_required(VERSION 4.0)
project(cacfar LANGUAGES CXX HIP)

find_package(hip REQUIRED)
file(GLOB_RECURSE SOURCES "src/*.cc" "kernels/*.hip")
add_executable(${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} PRIVATE hip::host)
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic -Werror)

add_custom_target(run
    COMMAND ${CMAKE_BINARY_DIR}/${PROJECT_NAME}
    DEPENDS ${PROJECT_NAME}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Launching executable..."
)
