"""
    fft_freqs(ts)

    Returns an array of DFT frequency points associated with the set of
    time-domain points.

    Assumes unit of argument `x` is sec. Output unit is in Hz (not rad/sec).
"""
function fft_freqs(ts)
    fs = (ts[2]-ts[1])^(-1) # sampling frequency
    N = Int(length(ts))
    deltaf = fs/N
    if N%2 ==0
        freqs = deltaf*(-N/2:N/2-1)
    else
        freqs = deltaf*(-(N-1)/2:(N-1)/2)
    end
    if length(ts) !== length(freqs)
        @printf("length(ts): %d, length(freqs): %d, delta_f: %f.\n",
                length(ts), length(freqs), deltaf)
        error("Number of time points should match the number of frequency
              points.")
    end
    return freqs
end
