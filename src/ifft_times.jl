"""
    ifft_times(fs)

    Returns an array of DFT time points associated with the set of
    frequency-domain points.

    Assumes unit of argument `x` is Hz (not rad/sec). Output unit is in s.
"""
function ifft_times(fs)
    deltaf = fs[2]-fs[1]
    N = Int(length(fs))
    if N%2 == 0
        delta_t = 1/(-2*fs[1])
    else
        delta_t = 1/(2*fs[end]+deltaf)
    end
    ts = (0:N-1)*delta_t
    return ts
end
