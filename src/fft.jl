"""
    Base.fft(td::TimeDomainData)

    Override Base.fft for the type CircuitSimulation.TimeDomainData.
"""
function Base.fft(td::TimeDomainData)
    Y = fft(td.vals)
    fs = fft_freqs(td.ts)
    return FrequencyDomainData(fs, Y)
end
"""
    Base.ifft(fd::FrequencyDomainData)

    Override Base.fft for the type CircuitSimulation.FrequencyDomainData.
"""
function Base.ifft(fd::FrequencyDomainData)
    y = ifft(fd.vals)
    ts = ifft_times(fd.fs)
    if any(abs.(angle.(y).%pi).>1e-1)
        error("Transformed data is not a vector of real values. Check to ensure
              your frequency-domain data is hermitian (complex conjugate
              symmetric about DC).")
    end
    return TimeDomainData(ts, real(y))
end
