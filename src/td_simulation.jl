"""
    td_simulation(F; S)

Requires frequency-domain transfer function F(f) and array of time points.
    """
function td_simulation(Z,ts)
    f(t) = real(QuadGK.quadgk(f->Z(f)*exp(2*pi*im*f*t),-1e4,1e4)[1])
    return f
end
