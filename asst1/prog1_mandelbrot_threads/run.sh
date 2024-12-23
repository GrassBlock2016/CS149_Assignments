make
for i in {2..8}
do
    for j in {1..2}
    do
        echo "Running with $i threads on view $j"
        ./mandelbrot -t $i -v j
    done
done