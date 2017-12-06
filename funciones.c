//
// Created by crist on 6/12/17.
//

#include "funciones.h"
#include "math.h"
#include <stdlib.h>

const char* functionKeys[] = {"sin", "cos", "tan", "asin", "acos", "atan", "sqrt", "log"};
double (*functionPointers[])(double) = {sin, cos, tan, asin, acos, atan, sqrt, log, NULL};

const char* reservedConstants[] = {"pi"};
double constantValues[] = {M_PI, 0};