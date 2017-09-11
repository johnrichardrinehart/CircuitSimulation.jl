"""
    fft_with_units(x,y)

Returns a tuple of frequency-domain points with associated frequencies.

Assumes unit of argument `x` is seconds.
"""
function fft_with_units(x, y)
    if length(x) !== length(y)
        error("length(x) !== length(y)")
    end
    out = fft(y)
    fs = (x[2]-x[1])^(-1) # sampling frequency
    N = Int(length(x))
    freqs = collect((fs/length(x))*(0:N-1))
    if N%2 ==0
        freqs[Int(.5*N+1):end] -= fs
    else
        freqs[Int(.5*(N+1)+1):N] -= fs
    end
    return (freqs, out)
end

"""
    ifft_with_units(x,y)

Returns a tuple of time-domain points with associated frequencies.

Assumes unit of argument `x` is Hertz (not rad/sec).
"""
function ifft_with_units(x, y)
    if length(x) !== length(y)
        error("length(x) !== length(y)")
    end
    out = ifft(y)
    deltaf = x[2]-x[1]
    N = Int(length(x))
    if N%2 == 0
        delta_t = 1/(2*(x[Int(.5*N)]+deltaf))
    else
        delta_t = 1/(2*(x[Int(.5*(N+1))])+deltaf)
    end
    tmax = 1/deltaf - delta_t # max time
    ts = 0:delta_t:tmax
    if length(ts) !== length(x)
        @printf("length(ts): %d, length(x): %d, delta_t: %f, tmax: %f.\n",
                length(ts), length(x), delta_t, tmax)
        error("Number of time points should match the number of frequency
              points.")
    end
    return (ts, out)
end
