/*! \file FilesAndFilters.cpp
    Example of working with data in files and using filters.
*/
/*! \example FilesAndFilters.cpp

    Example of working with data in files and using filters.
  
    # Contents 
    This example demonstrates:
        -# Reading data into a vector from a text file
        -# Using Persistence1D class to extract features
        -# Filtering features according to their persistence.
        -# Automatic reset of output variables - reused output variables are reset. 

    # Expected Output
    Output reference file: [persistence_base_dir]\\src\\examples\\FilesAndFilters\\FilesAndFiltersRes.ref
    with contents:

    \include FilesAndFiltersRes.ref

    # Code Documentation
*/

#include "..\..\persistence1d\persistence1d.hpp"

#include <fstream>

using namespace std;
using namespace p1d;

int main()
{
	//Declare class and input variables
	Persistence1D p;
	vector<float> data;
	float currdata; 
	ifstream datafile;
	char * filename = "data.txt";
	
	//Declare variables for results
	vector<TPairedExtrema> pairs;	
	vector<int> min, max;			
	int globalMinIndex;
	float globalMinValue;
	

	//Open the data file for reading
	datafile.open(filename);
	if (!datafile)
	{
		cout << "Cannot open data file for reading: " << filename << endl;
		return -1;
	}

	//Read the values from data file
	while(datafile >> currdata)
	{
		data.push_back(currdata);
	}
		
	datafile.close();
			
	//Find extrema and compute their persistence.
	p.RunPersistence(data);

	//Use the Get functions to get a copy of the results. 
	//You can use this function multiple times with multiple threshold values without re-running the 
	//main algorithm. 
	p.GetExtremaIndices(min, max);
	p.GetPairedExtrema(pairs);
	globalMinValue = p.GetGlobalMinimumValue();
	globalMinIndex = p.GetGlobalMinimumIndex();
	
	//To print the results - including all pairs and the global minimum, call PrintResults. 
	p.PrintResults();
	cout << endl;
		
	//Now set a threshold for features filtering
	//In this case, we choose a threshold between largest and smallest persistence, to select from of the data.
	float filterThreshold = (pairs.front().Persistence + pairs.back().Persistence)/2;
	
	//The vector which hold the data for the Get functions are being reset before use.
	//Use them to retrieve the filtered results:
	p.GetExtremaIndices(min, max, filterThreshold);
	p.GetPairedExtrema(pairs, filterThreshold);
	
	cout << "Filtered results with persistence > " << filterThreshold << endl;

	//To print the results, it is also possible to print the contents of the local pairs structure
	PrintPairs(pairs);

	//In this case, the global minimum needs to be printed manually
	cout << "Global minimum value: " << globalMinValue 
		 << " index: " << globalMinIndex  << endl << endl;
	
	//It is also possible to call PrintResuls with a threshold value to achieve identical results:
	cout << "PrintResults(filterThreshold) results:" << endl;
	p.PrintResults(filterThreshold);
	cout << endl;

	//Now set a threshold greater than the largest persistence, such that no paired extrema are returned:
	filterThreshold = pairs.back().Persistence + 1;	
	p.GetExtremaIndices(min, max, filterThreshold);
	p.GetPairedExtrema(pairs, filterThreshold);
	
	cout << "Filtered results with persistence > " << filterThreshold << endl;
	cout << "Number of found paired extrema: " << pairs.size() << endl;

	//Trying to print the results using the local pairs structure via PrintPairs will not print anything
	cout << "PrintPairs(pairs) start" << endl;
	PrintPairs(pairs);
	cout << "PrintPairs(pairs) end" << endl << endl;

	//But calling the class's PrintPairs will print the global minimum even when no 
	//pairs pass the persistence threshold.
	p.PrintResults(filterThreshold);
	
	return 0;
}
