"""
    td_simulation(F; S)

Requires frequency-domain transfer function F(f) and desired time point. F(f)
must be provided as a function of both positive and negative frequencies and the
optional bandwidth must be specified in Hz.
    """
function td_simulation(F,t0;bw=-1e4:1e4)
    f(t) = real(QuadGK.quadgk(f->F(f)*exp(2*pi*im*f*t),bw[1],bw[end])[1])
    return f(t0)
end
