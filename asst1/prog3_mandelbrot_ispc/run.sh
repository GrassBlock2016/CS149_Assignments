make
for i in 2, 4, 6, 8, 10, 12, 14, 16
do
    for j in {1..2}
    do
        echo "Running with $i tasks ISPC on view $j"
        ./mandelbrot_ispc -t $i -v $j
    done
done