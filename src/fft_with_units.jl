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

Assumes unit of argument `x` is rad/sec.
"""
function ifft_with_units(xdata, ydata)
end
