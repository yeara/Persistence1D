/*! \file run_persistence1d.cpp

* Main Matlab-C++ Interface file. 
*
* Compile with MEX to use as MATLAB interface for Persistence1D class.
* Tested on 32-bits only, MATLAB 2011b and above. 
* 
* Usage: [MinIndices MaxIndices Persistence GlobalMinIdx GlobalMinVal] = run_persistence1d(single(data))
*
* Supports input in single format. Output is INT32 and SINGLE.
*
* To see output messages in Matlab, uncomment line 38 before compilation.
*	
* @param[in] data                   A vector of data, sorted according to coordinates. 
*       							This should contain only data values to be sorted. 
*               					Assumes the data is one dimensional. 
*
* @param[out] MinIndices			Vector of (Matlab compatible) indices of local maxima.
* @param[out] MaxIndices			Vector of (Matlab compatible) indices of local minima.
* @param[out] Persistence           Vector of persistence of the paired extrema whose indices live in 
*									MinIndices and MaxIndices
* @param[out] GlobalMinIdx			Index (Matlab compatible) of global minimum.
* @param[out] GlobalMinVal			Value of global minimum.
*
************************************************/

#include <matrix.h>
#include <mex.h>
#include <algorithm>
#include <vector>
#include "..\src\persistence1d\persistence1d.hpp"

#define NUM_INPUT_VARIABLES 1
#define NUM_OUTPUT_VARIABLES 5
#define MATLAB_INDEXING true
#define NO_FILTERING 0.0

//uncomment the next line to see debug output in Matlab
//#define _DEBUG 

using namespace p1d;
using namespace std;

bool MxFloatArrayToFloatVector(const mxArray * input, std::vector<float> & data);
mxArray * VectorToMxSingleArray(const std::vector<float> data);
mxArray * VectorToMxSingleArray(const std::vector<int> data);
mxArray * VectorToMxSingleArray(const std::vector<TPairedExtrema> data);
mxArray * ScalarToMxSingleArray(const float data);
mxArray * ScalarToMxSingleArray(const int data);

bool CheckInput(const int nOuts, mxArray *outs[], const int nIns, const mxArray *ins[]);
void WriteVectorToMexOutput(const std::vector<float> data);
void WriteInputToVector(const mxArray *prhs[], std::vector<float> & data);

/*!
	Main MATLAB interface

	@param[in,out] nlhs		Number of left hand (output) matrices.
	@param[in,out] plhs		Pointers to left hand (output) matrices.
	@param[in] nrhs			Number of right hand (input) matrices.
	@param[in] prhs			Pointers to right hand (input) matrices.
*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//persistence and data variables
	Persistence1D p;
	std::vector<float> data; 

	//Variables to store persistence results
	std::vector<int> minIndices; 
	std::vector<int> maxIndices; 
	std::vector<TPairedExtrema> pairs;
	float gminValue;
	int gminIndex;
	
	//Assumption: Vector data lives in phrs[0]
	//Any deviation from this is not tolerated.

	//prhs - right hand - input - MATLAB standard naming convention
	//plhs - left hand - output
	if (!CheckInput(nlhs, plhs, nrhs, prhs)) return;

#ifdef _DEBUG	
    mexPrintf("Copying input data...\n");
#endif
	WriteInputToVector(prhs, data);
	
#ifdef _DEBUG
	WriteVectorToMexOutput(data);
#endif
	
#ifdef _DEBUG
    mexPrintf("Running Persistence1D...\n");
#endif
	p.RunPersistence(data);

#ifdef _DEBUG
    mexPrintf("Done.\n");
	mexPrintf("Getting results...\n");
#endif

    p.GetPairedExtrema(pairs, NO_FILTERING , MATLAB_INDEXING);
    gminIndex = p.GetGlobalMinimumIndex(MATLAB_INDEXING);
	gminValue = p.GetGlobalMinimumValue();
	p.GetExtremaIndices(minIndices, maxIndices, NO_FILTERING, MATLAB_INDEXING);

#ifdef _DEBUG
	mexPrintf("Done.\n");
	mexPrintf("Writing results to MATLAB...\n");
#endif
    	
	plhs[0] = VectorToMxSingleArray(minIndices);
	plhs[1] = VectorToMxSingleArray(maxIndices);
	plhs[2] = VectorToMxSingleArray(pairs);
	plhs[3] = ScalarToMxSingleArray(gminIndex);
	plhs[4] = ScalarToMxSingleArray(gminValue);

#ifdef _DEBUG	
	mexPrintf("Done.\n");
#endif
	return;
}

/*!
	Fills a given float data vector with values from float mxArray. 
	Warning - does not check if mxArray format is single.
*/
bool MxFloatArrayToFloatVector(const mxArray * input, std::vector<float> & data)
{
	if (mxGetClassID(input) != mxSINGLE_CLASS)
	{
		mexPrintf ("Error. Expecting SINGLE value matrix");
		return false; 
	}

	mwSize numElements = mxGetNumberOfElements(input);
	float *inputPt;
	inputPt = (float *)mxGetData(input);
	
	data.reserve(numElements);
	
	for (int i = 0; i < numElements; i++)
	{
		data.push_back((float)*inputPt++);
	}

	return true;
}
/*!
	Creates a 1x1 Single Type Matlab matrix from a single float value.
*/
mxArray * ScalarToMxSingleArray(const float data)
{
	mxArray * out = mxCreateNumericMatrix(1, 1, mxSINGLE_CLASS, mxREAL);
	float * mPt = (float *)mxGetData(out);

	*mPt++ = data;
	return out;	
}
mxArray * ScalarToMxSingleArray(const int data)
{
	return ScalarToMxSingleArray((float)data);
}

/*!
	Copies vector<float> data to 1-d MATLAB matrix

	@param[in] data A vector of float to copy.
*/
mxArray * VectorToMxSingleArray(const std::vector<float> data)
{
	mxArray * out = mxCreateNumericMatrix(data.size(), 1, mxSINGLE_CLASS, mxREAL);
	float * mPt = (float *)mxGetData(out);

	for (std::vector<float>::const_iterator pt = data.begin();
		pt != data.end(); pt++)
	{
		*mPt++ = *pt;
	}

	return out;	
}

/*!
	Copies vector<int> data to 1-d Single-type MATLAB matrix
	@param[in] data 	data to be copied to Matlab.
*/
mxArray * VectorToMxSingleArray(const std::vector<int> data)
{
	mxArray * out = mxCreateNumericMatrix(data.size(), 1, mxSINGLE_CLASS, mxREAL);
	float * mPt = (float *)mxGetData(out);

	for (std::vector<int>::const_iterator pt = data.begin();
		pt != data.end(); pt++)
	{
		*mPt++ = (float)*pt;
	}

	return out;	
}
/*!
	Creates a 1-d Single-Type MATLAB matrix with the persistence values from a vector of TPairedExtrema.
	@param[in] data 	Vector of paired extrema
*/
mxArray * VectorToMxSingleArray(const std::vector<TPairedExtrema> data)	
{
	mxArray * out = mxCreateNumericMatrix(data.size(), 1, mxSINGLE_CLASS, mxREAL);
	float * mPt = (float *)mxGetData(out);
		
	for (std::vector<TPairedExtrema>::const_iterator pt = data.begin();
		pt != data.end(); pt++)
	{
		*mPt++ = (*pt).Persistence;
	}
	return out;	
}
/*!
	Validates the following for the input:
	- Total number of arguments = 1
	- The only arguments should be data, in a 1-d matrix 
	- Matrix data type is single (AKA float)
	- No complex data
	- No char data

	Validates the following for the output:
	- There are three output variables

	@param[in]	nOuts	Number of output variables.
	@param[in]	outs	Array of pointers to output matrices.
	@param[in]	nIns	Number of input variables.
	@param[in]	ins		Array of pointers in input matrices.
*/
bool CheckInput(const int nOuts, mxArray *outs[], const int nIns, const mxArray *ins[])
{
	bool noerror = true;

	if (nIns != NUM_INPUT_VARIABLES) 
	{	
		mexPrintf("\nExpecting one input variables: data vector.");
		noerror = false;
	}
	if (nOuts != NUM_OUTPUT_VARIABLES) 
	{
		mexPrintf("\nExpecting five output variables: MinIndices MaxIndices Persistence GlobalMinIdx GlobalMinVal\n");
		noerror = false;
	}
	if (!mxIsNumeric(ins[0]) || mxIsComplex(ins[0]) || !mxIsSingle(ins[0]))
	{	
		mexPrintf ("\nExpecting the data vector to be REAL, SINGLE, matrix");
		noerror = false;
	}
	
	mwSize dims = mxGetNumberOfDimensions(ins[0]);
	if (dims > 2) 
    {
        mexPrintf("\nWarning. %d number of dimensions not supported, will handle data as one dimensional data", dims);
    }
    
	size_t mrows,ncols;
  	mrows = mxGetM(ins[0]);
	ncols = mxGetN(ins[0]);
	
	if (mrows!=1 && ncols!=1) //Input data should be 1-d vector shaped - results are not guaranteed for 2d data
	{
        mexPrintf("\nInput rows: %d cols: %d", mrows, ncols);
		mexPrintf("\nWarning. Expecting one dimensional vector data. Data vector contains: %d %d", mrows, ncols);
	}
	
	return noerror;
}
/*!
	Displays float-vector content in Matlab output window.

	@param[in] data		Float vector to write
*/
void WriteVectorToMexOutput(const std::vector<float> data)
{
	for (std::vector<float>::const_iterator it = data.begin(); 
		it != data.end(); it++)
	{
		mexPrintf("\n data[%d] %f",it-data.begin(),*it);
	}		
	mexPrintf("\n");
}
/*!
	Assumption - first input argument is a vector of 1-d data, 				 

	Copies the content of mxArray to a vector. 
	
	@param[in] inputs		Array of MATLAB matrix data, as received by mexFunction (MATLAB entrance point)
	@param[out] data		Vector which contain data for Persistence
*/
void WriteInputToVector(const mxArray *inputs[], std::vector<float> & data)
{
	MxFloatArrayToFloatVector(inputs[0], data);
}