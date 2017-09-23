function lossy_fit()
    # frequency dependencies
    fraction(x) = f -> (x[1]+(1+im*sign(f))*sqrt(abs(f))*x[2])/(1+im*f*x[3])
    real_part(x) = f -> real(sqrt(abs(fraction(x)(f)))*exp(im*angle(fraction(x)(f))/2))
    imag_part(x) = f -> imag(sqrt(abs(fraction(x)(f)))*exp(im*angle(fraction(x)(f))/2))

    real_model(w,p) = real_part(p).(w)
    imag_model(w,p) = imag_part(p).(w)

    xs = -1e3:1e-1:1e3
    # data to simulate below
    vals = rand(3)
    g(w) = real_part(vals)(w)
    h(w) = imag_part(vals)(w)
    real_ys = g.(xs)
    imag_ys = h.(xs)
    p0 = rand(3)

    # ForwardDiff.jacobian takes a function that only depends on the parameters to
    # be solved for.
    function real_jac(w,p)
        J = Array{Float64}(length(w),length(p))
        for i = 1:length(w)
            J[i,:] = ForwardDiff.gradient(pj -> real_part(pj)(w[i]),p)
        end
        return J
    end
    function imag_jac(w,p)
        J = Array{Float64}(length(w),length(p))
        for i = 1:length(w)
            J[i,:] = ForwardDiff.gradient(pj -> imag_part(pj)(w[i]),p)
        end
        return J
    end

    real_fit = LsqFit.curve_fit(real_model, real_jac, xs, real_ys, p0)
    imag_fit = LsqFit.curve_fit(imag_model, imag_jac, xs, imag_ys, p0)
    real_errors = LsqFit.estimate_errors(real_fit, .95)
    imag_errors = LsqFit.estimate_errors(imag_fit, .95)
    println("Vals used: ",vals)
    println("Vals solved (real): ", real_fit.param)
    println("Vals solved (imag): ", imag_fit.param)

    # using LsqFit
    # import ForwardDiff
    # # frequency dependencies
    # rac(Rs) = f -> (1+im*sign(f))*Rs*sqrt(abs(f))
    # rdc(Rdc) = f -> Rdc
    # Zl(L0) = f -> 2*pi*im*f*L0
    # #Zc(C0) = f -> f==0?Inf:1/(2*pi*f*C0)
    # Zc(C0) = f -> f==0?Inf:1/(2*pi*im*f*C0)
    # gac(C0,ϵ) = f -> 2*pi*f*C0*ϵ
    # # real and imag parts of Zc(f)
    # fraction(x) = f -> (rdc(x[1])(f)+rac(x[2])(f)+Zl(x[3])(f))/(gac(x[4],x[5])(f)+Zc(x[4])(f))
    # real_part(x) = f -> real(sqrt(abs(fraction(x)(f)))*exp(im*angle(fraction(x)(f))/2))
    # imag_part(x) = f -> imag(sqrt(abs(fraction(x)(f)))*exp(im*angle(fraction(x)(f))/2))
    #
    # real_model(w,p) = real_part(p).(w)
    # imag_model(w,p) = imag_part(p).(w)
    #
    # xs = vcat(-1e3:1e-1:-1e-1,1e-1:1e-1:1e3)
    # # data to simulate below
    # g(w) = real_part([1,2,3,5,1e-3])(w)
    # h(w) = imag_part([1,2,3,5,1e-3])(w)
    # real_ys = g.(xs)
    # imag_ys = h.(xs)
    # p0 = float(ones(5))
    #
    # # ForwardDiff.jacobian takes a function that only depends on the parameters to
    # # be solved for.
    # function real_jac(w,p)
    #     J = Array{Float64}(length(w),length(p))
    #     for i = 1:length(w)
    #         J[i,:] = ForwardDiff.gradient(pj -> real_part(pj)(w[i]),p)
    #     end
    #     return J
    # end
    # function imag_jac(w,p)
    #     J = Array{Float64}(length(w),length(p))
    #     for i = 1:length(w)
    #         J[i,:] = ForwardDiff.gradient(pj -> imag_part(pj)(w[i]),p)
    #     end
    #     return J
    # end
    #
    # real_fit = LsqFit.curve_fit(real_model, real_jac, xs, real_ys, p0)
    # #imag_fit = LsqFit.curve_fit(imag_model, imag_jac, xs, imag_ys, p0)
    # #real_errors = LsqFit.estimate_errors(real_fit, .95)
    # #imag_errors = LsqFit.estimate_errors(imag_fit, .95)
    # println(real_fit.param)
    # println(imag_fit.param)
end
