#include <stdlib.h>
#include <fstream>
#include <cstring>

#include "ExternalLibrary.h"

#define UNUSED(x) (void)(x);

static ModelicaUtilityFunctions_t s_callbacks = { NULL };

const char* externalFunction(const char *filename, const char *moduleName, const char *functionName, int nu, const double u[], int ny, double y[]) {

	UNUSED(moduleName)

	if (strcmp(functionName, "external_library_function")) {
		return "Argument functionName must be \"external_library_function\".";
	}

	std::ifstream infile(filename);

	if (!infile.is_open()) {
		return "Failed to open data file.";
	}

	double k;

	infile >> k;

	int s = (nu < ny) ? nu : ny;

	for (int i = 0; i < s; i++) {
		y[i] = u[i] + k;
	}

	return "";
}

class ExternalLibraryObject {

public:
	ExternalLibraryObject(double k) {
		this->k = k;
	}

	void evaluate(int nu, const double u[], int ny, double y[]) {

		if (nu != ny) {
			s_callbacks.ModelicaFormatError("The number of inputs (%d) must be equal to the number of outputs (%d).", nu, ny);
			return;
		}

		int s = (nu < ny) ? nu : ny;

		for (int i = 0; i < s; i++) {
			y[i] = u[i] + k;
		}
	}

protected:
	double k;

};

void* createExternalObject(const char *filename, const char *moduleName, const char *className, const ModelicaUtilityFunctions_t *callbacks) {

	UNUSED(moduleName)

	s_callbacks = *callbacks;

	const char *error = nullptr;
	std::ifstream *infile = nullptr;

	if (!filename) {
		error = "Argument filename must not be NULL.";
		goto out;
	}

	if (!className || strcmp(className, "ExternalLibraryObject")) {
		error = "Argument className must be \"ExternalLibraryObject\".";
		goto out;
	}

	infile = new std::ifstream(filename);

	if (!infile->is_open()) {
		error = "Failed to open data file.";
		goto out;
	}

	double k;

	*infile >> k;

out:
	if (infile) delete infile;

	if (error) {
		if (callbacks->ModelicaError) {
			callbacks->ModelicaError(error);
		}
		return nullptr;
	}

	return new ExternalLibraryObject(k);
}

void evaluateExternalObject(void *externalObject, int nu, const double u[], int ny, double y[]) {
	if (!externalObject) return;
	ExternalLibraryObject *externalLibraryObject = static_cast<ExternalLibraryObject*>(externalObject);
	externalLibraryObject->evaluate(nu, u, ny, y);
}

void freeExternalObject(void *externalObject) {
	if (!externalObject) return;
	ExternalLibraryObject *externalLibraryObject = static_cast<ExternalLibraryObject*>(externalObject);
	delete externalLibraryObject;
}
