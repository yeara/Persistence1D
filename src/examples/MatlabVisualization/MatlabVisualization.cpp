/*! \file MatlabVisualization.cpp
    Demonstrates how to run the C++ code and visualize the results using Matlab.
*/
/*! \example MatlabVisualization.cpp

    Demonstrates how to run the C++ code and visualize the results using Matlab.
        
    # Contents
    This example demonstrates how to:
    -# Read data from a file, 
    -# Use Persistence1D class to extract extrema
    -# Filter results according to persistence values.
    -# Get results in Matlab output format
    -# Visualize results using Matlab scripts.

    # Expected Results 
    Reference output file: [persistence_base_dir]\\src\\examples\\MatlabVisualization\\MatlabVisualizationRes.ref
    with contents:
    \include MatlabVisualizationRes.ref

    # Results Visualization
    -# Start Matlab
    -# Change the directory to [persistence_base_dir]\\matlab
    -# Run: visualize_features('..\\data.txt', '..\\res.txt')

    ## Matlab Plot of Results
    \image html MatlabVisRes.png "Matlab Plot of Results"
    \image latex MatlabVisRes.png "Matlab Plot of Results"

    # Code Documentation
*/

#include "..\..\persistence1d\persistence1d.hpp"
#include <fstream>

using namespace std;
using namespace p1d;

int main()
{
	//Input and class variables declaration
	Persistence1D p;
	vector<float> data;
	float currdata; 
	ifstream datafile;
	ofstream outfile;
	char * filename = "data.txt";
	char * outfilename = "res.txt";
	bool enableMatlabIndexing = true;

	//Output variables declaration
	vector<int> min, max;			
	int globalMinIndex;
	
	//Open and read the data file
	datafile.open(filename);
	if (!datafile)
	{
		cout << "Cannot open data file for reading: " << filename << endl;
		return -1;
	}

	while(datafile >> currdata)
	{
		data.push_back(currdata);
	}
		
	datafile.close();
			
	//To start data processing, run persistence on data
	p.RunPersistence(data);

	//It is possible to verify the correctness of the results via sanity tests. 
	//Check the function documentation for further information.
	if (!p.VerifyResults()) 
	{
		cout << "ERROR" << endl;
	}
	
	//Now, set a threshold for features filtering
	float filterThreshold = 1.0;
	
	//Retrieve the filtered results from the class. 
	//Since results are intended to be used within Matlab, set MatlabIndexing in all Get function calls
	//to get 1-based indexing results. 
	//Results retrieved without MatlabIndexing set to true are 0-based.
	p.GetExtremaIndices(min, max, filterThreshold, enableMatlabIndexing);
	globalMinIndex = p.GetGlobalMinimumIndex(enableMatlabIndexing);
	
	//Print all found indices to a file
	outfile.open(outfilename);
	if (!outfile)
		return -2;
	
	for (unsigned int i = 0; i < min.size() && i < max.size(); i++)
	{
		outfile << min[i] << endl;
		outfile << max[i] << endl;
	}

	//Add the global minimum to the file as well:
	//The global minimum does is not returned via GetExtremaIndices, as it is not paired.
	outfile << globalMinIndex << endl;

	outfile.close();

	//To visualize the results:
	//Start Matlab
	//Change the directory to [persistence_base_dir]\matlab
	//Run: visualize_features('..\src\examples\MatlabVisualization\data.txt', '..\src\examples\MatlabVisualization\res.txt')
	
	return 0;
}