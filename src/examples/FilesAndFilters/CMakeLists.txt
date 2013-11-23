add_executable (FilesAndFilters FilesAndFilters.cpp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/data.txt ${CMAKE_CURRENT_BINARY_DIR}/data.txt COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/FilesAndFiltersRes.ref ${CMAKE_CURRENT_BINARY_DIR}/FilesAndFiltersRes.ref COPYONLY)