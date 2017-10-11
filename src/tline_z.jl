"
    tline_z(Rdc,Rs,L0,epsilon,C0)

tline_fd generates a frequency-domain representation of the characteristic
impedance of a transmission line using a popular model of R(w), L(w), G(w), and
C(w). Rs is a skin-effect resistance quantity (units of Ohms/sqrt(Hz)) and
epsilon is the imaginary part of the loss tangent (dielectric loss).
"
function tline_z(Rdc,Rs,L0,epsilon,C0)
    zr(rdc,rs) = f -> rdc+(1+im*sign(f))*rs*sqrt(abs(f))
    zl(l0) = f -> 2*pi*im*f*l0
    zg(ep,c0) = f-> 2*pi*f*sign(f)*ep*c0
    zc(c0) = f -> 1/(2*pi*im*f*c0)
    frac(f) = (zr(Rdc,Rs)(f)+zl(L0)(f)) / (zg(epsilon,C0)(f) + zc(C0)(f))
    return function(f)
        f==0?sqrt(Rdc):abs(frac(f))^(.5)*cis(angle(frac(f))/2)
    end
end
