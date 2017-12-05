cmake_minimum_required(VERSION 3.8)
project(Calculadora)

set(CMAKE_C_STANDARD 11)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(MyParser calculadora.y ${CMAKE_CURRENT_BINARY_DIR}/calculadora.tab.c COMPILE_FLAGS "--no-lines -d")
FLEX_TARGET(MyScanner calculadora.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c COMPILE_FLAGS "-L --noyywrap --header-file=calculadora.h")
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

set(SOURCE_FILES main.c tablaSimbolos.h tablaSimbolos.c calculadora.h ${BISON_MyParser_OUTPUTS} ${FLEX_MyScanner_OUTPUTS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Calculadora ${SOURCE_FILES})

target_link_libraries(Calculadora m)