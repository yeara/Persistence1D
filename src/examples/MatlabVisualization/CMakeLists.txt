add_executable (MatlabVisualization MatlabVisualization.cpp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/data.txt ${CMAKE_CURRENT_BINARY_DIR}/data.txt COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/MatlabVisualizationRes.ref ${CMAKE_CURRENT_BINARY_DIR}/MatlabVisualizationRes.ref COPYONLY)