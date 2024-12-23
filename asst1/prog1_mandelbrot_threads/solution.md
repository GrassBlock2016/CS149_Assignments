# Device

CPU: Apple M3 (8) @ 4.06 GHz

# Solution

Fill the function `void workerThreadStart(WorkerArgs * const args)` in `mandelbrotThread.cpp`

```cpp
void workerThreadStart(WorkerArgs * const args) {
    // double startTime = CycleTimer::currentSeconds();

    mandelbrotSerial(args->x0, args->y0, args->x1, args->y1, 
    args->width, args->height, 
    args->threadId * (args->height / args->numThreads), args->height / args->numThreads,
    args->maxIterations, 
    args->output);

    // handle the situation that height cannot be divided by numThreads (1200 / 7)
    if (args->height % args->numThreads != 0 && args->threadId == args->numThreads - 1) {
        mandelbrotSerial(args->x0, args->y0, args->x1, args->y1, 
        args->width, args->height, 
        args->threadId * (args->height / args->numThreads), args->height - args->threadId * (args->height / args->numThreads),
        args->maxIterations, 
        args->output);
    }

    // double endTime = CycleTimer::currentSeconds();
    // printf("Thread %d took %.3f ms\n", args->threadId, (endTime - startTime) * 1000);
}
```

# Result

How many speedup from threads

|threads<br />view|2<br />|3<br />|4<br />|5<br />|6<br />|7<br />|8<br />|
|---|---|---|---|---|---|---|---|
|1|1.95x|1.58x|2.35x|2.32x|3.04x|3.10x|3.65x|
|2|1.95x|1.58x|2.35x|2.32x|3.03x|3.15x|3.58x|

# Analysis

If you measure the amount of time each thread requires to complete its work, you can see that some threads may cost more time than other threads. Maybe it is because that their work is more complex (as you can see from the result `ppm` file). In addition, we can not ignore the time that inter-thread communication, so the multi-threading speedup is not proportional to the number of threads.

In order to maximum the speedup, consider to make each thread's computation more evenly distributed.