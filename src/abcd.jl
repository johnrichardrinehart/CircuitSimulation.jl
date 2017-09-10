"
abcd_tline(l(w),c(w),r=w->0,g=w->0)

abcd_tline returns a function (of frequency and distance) which, itself, returns an abcd
matrix.

abcd_tline requires as arguments:

1. l(w) -> inductance per unit length as a function of frequency (rad/sec)
1. c(w) -> capacitance per unit length as a function of frequency (rad/sec)
1. r(w) -> series resistance per unit length as a function of frequency (rad/sec)
1. g(w) -> susceptance per unit length as a function of frequency (rad/sec)

abcd_tline returns a function f(ω,d) which, when supplied an angular frequency,
ω, and transmission line length, d, returns an ABCD matrix corresponding to this
transmission line.
"
function abcd_tline(l,c,r=w->0,g=w->0)
    return function abcd(w,d)
        Z0(w) = sqrt((r(w)+im*w*l(w))/(g(w)+im*w*c(w)))
        γ(w) = sqrt((r(w)+im*w*l(w))*(g(w)+im*w*c(w)))
        return [cosh(γ(w)*d) Z0(w)*sinh(γ(w)*d);
                 sinh(γ(w)*d)/Z0(w) cosh(γ(w)*d)]
    end
end
