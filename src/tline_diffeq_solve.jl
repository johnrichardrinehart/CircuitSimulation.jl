# Obtained from https://en.wikipedia.org/wiki/Telegrapher%27s_equations#Lossy_transmission_line
"
    telegrapher(L,C,R=0,G=0,n=100)

returns an array of differential equations that can be
used to solve for the travelling voltages and currents as a function of time.
All quantities are expected to be per-length quantities (in S.I. units).

The problem is solved by discretizing the transmission line into n sections. If
the solution is too coarse then try changing n.
"
function telegrapher(L, C, R=0, G=0 ;n=100, vs=t->1, is=t->0)
    if L == 0 || C == 0
        error("Both the inductance and capacitance need to be non-zero.")
    end
    return function(t,u,du)
        B2(t,view(u,n+1:2n),view(du,1:n))
        scale!(view(du,1:n), -1/L)

        B1(t,view(u,1:n),view(du,n+1:2n))
        scale!(view(du,n+1:2n), -1/C)
    end
end
"
    tline_solve(f,L,C,R=0,G=0,t=(0,1),n=100)

Solves for the time-domain response of a transmission line to an incident
voltage waveform f(t).

### Arguments
u0: initial voltage applied to the line\n
t: solution interval\n
n: number of tline discretizations\n
"
function tline_solve(u0,vs,is,L,C,R=0,G=0;t=(0.,1.),n=100,dt=1e-3)
    prob = DifferentialEquations.ODEProblem(telegrapher(L,C,R,G,n=n,vs=vs),u0,t)
    #solver = DifferentialEquations.Euler()
    solver = DifferentialEquations.CVODE_BDF()
    sol = DifferentialEquations.solve(
                                      prob,
                                      solver,
                                      reltol=1e-8,
                                      abstol=1e-8,
                                      dt=dt
                                     )
    return sol
end
