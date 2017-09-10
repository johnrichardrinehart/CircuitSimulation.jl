# The following is based on doi 10.1109/22.275248
"
    abcd2s(ABCD(ω);Z01=50,Z02=50)

    returns a function of frequency given a function, ABCD(ω). The result
    possible depends on frequency and (possibly complex) source (Z01) and load
    (Z02) impedances - source and load impedances should be provided as
    functions of frequency.
"
function abcd2s(abcd_matrix;Z01=w->50, Z02=w->50)
    if size(abcd_matrix(0)) != (2,2)
        error("abcd_matrix must by a 2x2 matrix.")
    end
    A(w) = abcd_matrix(w)[1,1]
    B(w) = abcd_matrix(w)[1,2]
    C(w) = abcd_matrix(w)[2,1]
    D(w) = abcd_matrix(w)[2,2]
    R01(w) = real(Z01(w)); R02(w) = real(Z02(w));

    denominator(w) = A(w)*Z02(w) + B(w) + C(w)*Z01(w)*Z02(w) + D(w)*Z01(w)

    S11(w) = A(w)*Z02(w)+B(w)-C(w)*conj(Z01(w))*Z02(w)-D(w)*conj(Z01(w))

    S12(w) = 2*(A(w)*D(w)-B(w)*C(w))*sqrt(R01(w)*R02(w))
    S21(w) = 2*sqrt(R01(w)*R02(w))
    S22(w) = (-A(w)*conj(Z02(w))+B(w)-C(w)*Z01(w)*conj(Z02(w))+D(w)*Z01(w))
    return w -> (denominator(w))^-1*[S11(w) S12(w); S21(w) S22(w)]
end
