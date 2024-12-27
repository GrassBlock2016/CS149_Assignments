# Device

CPU: 

Apple M3 (8) @ 4.06 GHz (Using `Makefile` to build)

Intel® Core™ i7-12700K (`Makefile copy`)

# Solution & Results

1.  

```
[sqrt serial]:          [721.042] ms
[sqrt ispc]:            [159.645] ms
[sqrt task ispc]:       [26.775] ms
                                (4.52x speedup from ISPC)
                                (26.93x speedup from task ISPC)
```

(taskNum = 64)

2. 3. 

When modify all the values to 1.0f

```
[sqrt serial]:          [7.619] ms
[sqrt ispc]:            [2.309] ms
[sqrt task ispc]:       [2.015] ms
                                (3.30x speedup from ISPC)
                                (3.78x speedup from task ISPC)
```

When modify all the values to a specific value that range from 0 to 3 except for 1.0f, the **ISPC speedup** comes from `2.60x` to `2.80x` and the **ISPC task (64 tasks) speedup** comes from `12.20x` to `13.50x`

> I only tested 0.333f, 0.666f, 1.333f, 1.666f, 2.000f, 2.333f, 2.666f and 3.000f here

By the way, when the value comes to 0f, The whole program would get stuck and its CPU usage would be extremely high.

We can colude that when there is a specific value in values array, the computing tasks are distributed more evenly, so the speedup is far inferior to the random values array. In addition, when the value comes to 1.0f, the amount of computation will become very small, so the speedup from ISPC is similiar to that from task ISPC, as the image of `Convergence of sqrt` in [README.md](../README.md) shows.

> The above all runs on an M3, and since the M3 doesn't have AVX2 register, the following will run on an Intel CPU

4. TODO!()