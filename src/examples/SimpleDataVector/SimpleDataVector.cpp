/*! \file SimpleDataVector.cpp
    Basic example which demonstrates how to use the Persistence1D class for finding extrema features.
*/
/*! \example SimpleDataVector.cpp

    Basic example which demonstrates how to use the Persistence1D class for finding extrema features.
  
    # Contents
    This example demonstrates how to:
    -# Create a data vector.
    -# Run persistence on data vector.
    -# Filter extrema by a persistence threshold.
    -# Print the filtered extrema.

    # Expected Output
    Output reference file: [persistence_base_dir]\\src\\examples\\SimpleDataVector\\SimpleDataVectorRes.ref
    with contents:
    \include SimpleDataVectorRes.ref

    # Code Documentation
*/

#include "..\..\persistence1d\persistence1d.hpp"

using namespace std;
using namespace p1d;

int main()
{
	//Create some data
	vector< float > data;
	data.push_back(2.0);   data.push_back(5.0);   data.push_back(7.0);
	data.push_back(-12.0); data.push_back(-13.0); data.push_back(-7.0);
	data.push_back(10.0);  data.push_back(18.0);  data.push_back(6.0);
	data.push_back(8.0);   data.push_back(7.0);   data.push_back(4.0);

	//Run persistence on data - this is the main call.
	Persistence1D p;
	p.RunPersistence(data);

	//Get all extrema with a persistence larger than 10.
	vector< TPairedExtrema > Extrema;
	p.GetPairedExtrema(Extrema, 10);

	//Print all found pairs - pairs are sorted ascending wrt. persistence.
	for(vector< TPairedExtrema >::iterator it = Extrema.begin(); it != Extrema.end(); it++)
	{
		cout << "Persistence: " << (*it).Persistence
			 << " minimum index: " << (*it).MinIndex
			 << " maximum index: " << (*it).MaxIndex
			 << std::endl;
	}

	//Also, print the global minimum.
	cout << "Global minimum index: " << p.GetGlobalMinimumIndex() 
		 << " Global minimum value: " << p.GetGlobalMinimumValue() << endl;

	/*
		Note that filtering and printing can also be done with one single function call:
		p.PrintResults(10);
	*/

	return 0;
}
