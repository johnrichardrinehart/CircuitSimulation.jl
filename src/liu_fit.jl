function liu_fit(xdata, ydata)
    # each term in Liu's time-domain impedance is denoted by m# (i.e. m1, m2, m3)
    m1(L) = 2*L/xdata[end]
    # m2 is complicated because of the sqrt(t). The units don't strictly work out
    # because there's supposed to be a 1/sqrt(Hz) in the denominator. Now, L is to
    # be computed nH and t should be provided as ns. So, scaling everything would
    # result in something like (Rs*1e-6)*sqrt.(t*1e-9)/(pi*L*1e-9). But, we don't
    # want Julia to have to work with big numbers if she doesn't have to. So, we'll
    # combine all of these exponentials into one: 10^-6*10^-4.5*10^9 = 10^-1.5
    m2(t,Rs,L) = 10^-1.5*Rs*sqrt.(t)/(pi*L) # Rs - microOhms, t - ns, L - nH
    m3(t,Rdc,L) = .5*Rdc*t/L # Rdc- ohms, t - ns, L - nH
    m(t,p) = m1(p[1])*(1+m2(t,p[2],p[1])+m3(t,p[3],p[1])) # p[1:3] -> L,Rs,Rdc
    fit = LsqFit.curve_fit(m,xdata,ydata,rand(3))
    errors = LsqFit.estimate_errors(fit)
    L = fit.param[1]
    C = xdata[end]^2/(4*L)
    Rs = fit.param[2]
    Rdc = fit.param[3]
    #@printf("L [nH]: %2.2f +/- %2.2f (%2.2f,%2.2f)\n", L, errors[1],
            #fit.param[1]-errors[1],fit.param[1]+errors[1])
    #@printf("C [μF]: %2.2f\n", C)
    #@printf("Rs [μΩ]: %2.2f +/- %2.2f (%2.2f,%2.2f)\n", Rs, errors[2],
            #fit.param[2]-errors[2],fit.param[2]+errors[2])
    #@printf("Rdc [Ω]: %2.2f +/- %2.2f (%2.2f,%2.2f)\n", Rdc, errors[3],
            #fit.param[3]-errors[3],fit.param[3]+errors[3])
    return Dict(
                "L" => L,
                "C" => C,
                "Rs" => Rs,
                "Rdc" => Rdc,
               )
end
