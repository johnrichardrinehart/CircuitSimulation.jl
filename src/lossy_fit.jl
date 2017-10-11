"""

    lossy_fit(xs,ys;Rdc=1e0,Rs=1e-6,L0=1e-9,epsilon=1e-3,C0=1e-12,show_trace=false,maxIter=1000)


lossy_fit accepts two positional arguments

xs::Float{64,1} - Array of sampled frequencies
ys::Float{64,1} - Array of frequency response values

and 7 keyword arguments

Rdc::Float64
Rs::Float64
L0::Float64
epsilon::Float64
C0::Float64
show_trace::Bool
maxIter::Int32

where the first 5 keyword arguments are the sizes (in SI units) of the guesses
of each of the fitted parameter values and the last two control the behavior of
LsqFit.jl.

lossy_fit computes a fit of the parameters Rdc (DC resistive loss), Rs (skin effect loss),
L0 (series inductance), loss tangent, C0 (shunt capacitance) provided the
frequency-domain response of a device under test assuming the model described in
[[RINEHART2017]].
"""
function lossy_fit(xs,ys;Rdc=1e0,Rs=1e-6,L0=1e-9,epsilon=1e-3,C0=1e-12,show_trace=false,maxIter=1000)
    z(p) = f -> tline_z_fd(p...)(f)
    # re-define the model to conform to LsqFit expectations
    model(f,p) = vcat(real(z(p).(f)), imag(z(p).(f)))

    # ForwardDiff.jacobian takes a function that only depends on the parameters to
    # be solved for.
    function model_jac(w,p)
        return ForwardDiff.jacobian(pj -> model(w,pj), p)
    end
    # guess
    p0 = [Rdc, Rs, L0, epsilon, C0]
    fit = LsqFit.curve_fit(model, model_jac, xs, ys, p0,
                           show_trace=show_trace,
                           lower=zeros(5)+eps(),
                           maxIter=maxIter,
                        )
    fit_errors = LsqFit.estimate_errors(fit, .95)
    return Dict("vals" => fit.param, "errors" => fit_errors)
end

"""
    impedance(ZR,ZL,ZG,ZC)

returns the impedance function to be fit.
"""
function impedance(ZR,ZL,ZG,ZC)
    frac(p) = f -> (ZR(p[1],p[2])(f)+ZL(p[3])(f)) / (ZG(p[4],p[5])(f) + ZC(p[5])(f))
    function Z(p)
        return function(f)
            f==0?sqrt(p[1]):abs(frac(p)(f))*cis(angle(frac(p)(f)))
        end
    end
    return Z
end
