"""
    lossy_fit(Rdc, Rs, L0, G, C0)

Computes a fit of the parameters Rdc (DC resistive loss), Rs (skin effect loss),
L0 (series inductance), G (shunt admittance), C0 (shunt capacitance) where these
arguments are provided as

Rdc: Float64
Rs: Float64
L0: Float64
epsilon: Float64
C0: Float64
"""
function lossy_fit(;maxIter=1000)
    # construct the general form for the frequency dependence of the parameters
    # provided
    zr(rdc,rs) = f -> rdc+(1+im*sign(f))*rs*sqrt(abs(f))
    zl(l0) = f -> 2*pi*f*l0
    zg(epsilon,c0) = f-> 2*pi*f*epsilon*c0
    zc(c0) = f -> 1/(2*pi*im*c0)

    # obtain objective functions for both the real and imaginary parts of the
    # impedance
    z = impedance(zr,zl,zg,zc)

    # re-define the model to conform to LsqFit expectations
    model(f,p) = vcat(real(z(p).(f)), imag(z(p).(f)))

    # generate artificial "data" to fit below
    xs = -1e3:1e-1:1e3
    vals = rand(5)
    ys = model(xs,vals)
    p0 = rand(5)

    # ForwardDiff.jacobian takes a function that only depends on the parameters to
    # be solved for.
    function model_jac(w,p)
        return ForwardDiff.jacobian(pj -> model(w,pj), p)
    end

    fit = LsqFit.curve_fit(model, model_jac, xs, ys, p0,
                           maxIter=maxIter,
                           lower=zeros(5)+eps(Float64),
                        )
    fit_errors = LsqFit.estimate_errors(fit, .95)
    println("Vals used: ", collect(vals))
    println("Vals solved: ", fit.param)
    println("Estimated errors: ", fit_errors)
end

"""
    impedance(R,L,G,C)

returns a tuple of functions that return the real and imaginary parts of the
model objective function.
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
