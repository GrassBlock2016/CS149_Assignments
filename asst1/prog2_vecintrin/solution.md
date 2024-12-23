# Device

CPU: Apple M3 (8) @ 4.06 GHz

# Solution

Fill the function `void clampedExpVector(float *values, int *exponents, float *output, int N)` in `main.cpp`

```cpp
void clampedExpVector(float *values, int *exponents, float *output, int N)
{

    //
    // CS149 STUDENTS TODO: Implement your vectorized version of
    // clampedExpSerial() here.
    //
    // Your solution should work for any value of
    // N and VECTOR_WIDTH, not just when VECTOR_WIDTH divides N
    //

    // for (int i = 0; i < N; i++)
    for (int i = 0; i < N; i += VECTOR_WIDTH) {   
        __cs149_mask maskInit = _cs149_init_ones();

        // float x = values[i];
        __cs149_vec_float x;
        _cs149_vload_float(x, values + i, maskInit);

        // int y = exponents[i];
        __cs149_vec_int y;
        _cs149_vload_int(y, exponents + i, maskInit);

        // if (y == 0) output[i] = 1.f;
        __cs149_vec_int vecIntZero = _cs149_vset_int(0);
        __cs149_vec_float vecFloatOne = _cs149_vset_float(1.f);
        __cs149_mask maskYEqualZero;
        _cs149_veq_int(maskYEqualZero, y, vecIntZero, maskInit);
        _cs149_vstore_float(output + i, vecFloatOne, maskYEqualZero);

        // else
        // float result = x;
        __cs149_mask maskYNotEqualZero = _cs149_mask_not(maskYEqualZero);
        __cs149_vec_float result;
        _cs149_vmove_float(result, x, maskYNotEqualZero);

        // int count = y - 1;
        __cs149_vec_int count;
        __cs149_vec_int vecIntOne = _cs149_vset_int(1);
        _cs149_vsub_int(count, y, vecIntOne, maskYNotEqualZero);

        // while (count > 0)
        __cs149_mask maskCountGreaterThanZero;
        __cs149_mask maskCountNotGreaterThanZero;
        _cs149_vgt_int(maskCountGreaterThanZero, count, vecIntZero, maskYNotEqualZero);
        maskCountNotGreaterThanZero = _cs149_mask_not(maskCountGreaterThanZero);
        /*
        Figure out the logic of the loop.
        Only when all the elements in the vec dissatisfied the condition,
        the loop will not be run.
        Otherwise, the loop should be run and the mask will
        automatically judge which elements should be handled
        */
        while (_cs149_cntbits(maskCountNotGreaterThanZero) != VECTOR_WIDTH) {
            // result *= x;
            _cs149_vmult_float(result, result, x, maskCountGreaterThanZero);

            // count--;
            _cs149_vsub_int(count, count, vecIntOne, maskCountGreaterThanZero);

            // Don't forget to update masks
            _cs149_vgt_int(maskCountGreaterThanZero, count, vecIntZero, maskInit);
            maskCountNotGreaterThanZero = _cs149_mask_not(maskCountGreaterThanZero);
        }

        // if result > 9.999999f result = 9.999999f;
        __cs149_vec_float vecFloatMax = _cs149_vset_float(9.999999f);
        __cs149_mask resultGreaterThanMax;  // It also includes "y != 0"
        _cs149_vgt_float(resultGreaterThanMax, result, vecFloatMax, maskYNotEqualZero);
        _cs149_vset_float(result, 9.999999f, resultGreaterThanMax);

        // output[i] = result;
        _cs149_vstore_float(output + i, result, maskYNotEqualZero);
    }
}
```

Fill the function `float arraySumVector(float *values, int N)` in `main.cpp`

```cpp
float arraySumVector(float *values, int N)
{

    //
    // CS149 STUDENTS TODO: Implement your vectorized version of arraySumSerial here
    //

    float sum[VECTOR_WIDTH];
    __cs149_mask maskInit = _cs149_init_ones();
    __cs149_vec_float valueVec;
    __cs149_vec_float sumVec = _cs149_vset_float(0.f);

    for (int i = 0; i < N; i += VECTOR_WIDTH) {
        _cs149_vload_float(valueVec, values + i, maskInit);
        _cs149_vadd_float(sumVec, sumVec, valueVec, maskInit);
    }

    /*
    The loop is not only just load values into valueVec, 
    but also add up the elements in the corresponding positions 
    on each cycle (every VECTOR_WIDTH).
    */ 

    /* 
    A wonderful solution
    eg. I want to get the sum of [1, 2, 3, 4]
    [1, 2, 3, 4] -> [1+2, 1+2, 3+4, 3+4] -> [1+2, 3+4, 1+2, 3+4] -> [1+2+3+4, 1+2+3+4, 1+2+3+4, 1+2+3+4]
    */
    _cs149_hadd_float(sumVec, sumVec);
    _cs149_interleave_float(sumVec, sumVec);
    _cs149_hadd_float(sumVec, sumVec);
    _cs149_vstore_float(sum, sumVec, maskInit);

    return sum[0];
    // return 0.0;
```

# Result
```bash
$ ./myexp -s 1000
CLAMPED EXPONENT (required) 
Results matched with answer!
****************** Printing Vector Unit Statistics *******************
Vector Width:              4
Total Vector Instructions: 12140
Vector Utilization:        84.1%
Utilized Vector Lanes:     40832
Total Vector Lanes:        48560
************************ Result Verification *************************
Passed!!!

ARRAY SUM (bonus) 
Passed!!!
```