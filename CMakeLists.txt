cmake_minimum_required (VERSION 2.6) 

project (PERSISTENCE1D) 
add_subdirectory(src)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
SET_PROPERTY(TARGET FilesAndFilters          PROPERTY FOLDER "Examples")
SET_PROPERTY(TARGET MatlabVisualization      PROPERTY FOLDER "Examples")
SET_PROPERTY(TARGET SimpleDataVector         PROPERTY FOLDER "Examples")
SET_PROPERTY(TARGET tests         PROPERTY FOLDER "Tests")

