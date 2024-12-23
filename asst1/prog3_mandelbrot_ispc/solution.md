# Device

CPU: Apple M3 (8) @ 4.06 GHz

# Solution

Just changed the way passing on the arguments in `main.cpp` and `mandelbrot.ispc`

In addition, I also changed `Makefile` to allow the program can be built on my device.

# Result

How many speedup from ispc

|taskNum<br />view|ISPC without task<br />|2<br />|4<br />|6<br />|8<br />|10<br />|12<br />|14<br />|16<br />|
|---|---|---|---|---|---|---|---|---|---|
|1|3.45x|6.78x|8.26x|10.75x|11.61x|13.69x|15.27x|15.89x|16.80x|
|2|2.69x|4.46x|6.54x|8.69x|10.75x|12.95x|12.75x|13.10x|13.34x|