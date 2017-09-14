function Plots.plot(d::CircuitSimulation.TimeData)
    scale = (1,"");
    mint = d.ts[2]
    if mint < 1e-15
        scale = (1e15, "f")
    elseif mint < 1e-12
        scale = (1e12, "p")
    elseif mint < 1e-9
        scale = (1e9, "n")
    elseif mint < 1e-6
        scale = (1e6, "m")
    elseif mint < 1e-3
        scale = (1e3, "m")
    end
    b = Plots.plot(
                   xaxis=(@sprintf("Time [%ss]",scale[2])),
                   size=(1200,800),
                   yaxis=("Time-domain Function"),
                   leg=false,
                  )
    Plots.plot!(b,d.ts*scale[1], d.vals,)
end

function Plots.plot(d::FrequencyData; style=:magphase)
    scale = (1,"");
    maxf = maximum(d.fs)
    if maxf > 1e15
        scale = (1e-15, "P")
    elseif maxf > 1e12
        scale = (1e-12, "T")
    elseif maxf > 1e9
        scale = (1e-9, "G")
    elseif maxf > 1e6
        scale = (1e-6, "M")
    elseif maxf > 1e3
        scale = (1e-3, "k")
    end
    b = Plots.plot(
                   xaxis=(@sprintf("Frequency [%sHz]",scale[2])),
                   size=(1200,800),
                   layout=Plots.@layout([a; b]),
                   leg=[false false],
                  )
    if style==:magphase
        Plots.plot!(b,fftshift(d.fs)*scale[1],
                    hcat(fftshift(abs.(d.vals)),fftshift(rad2deg.(angle.(d.vals)))),
                    title=["Magnitude" "Phase"],
                    ylabel=["Magnitude (L1 norm)" "Phase [deg]"],
                   )
    elseif style==:realimag
        Plots.plot!(b,fftshift(d.fs)*scale[1],
                    hcat(fftshift(real.(d.vals)),fftshift(imag.(d.vals))),
                    title=["Real" "Imag"],
                    ylabel=["Real" "Imag"],
                   )
    else
        error("'style' must be either :magphase or :realimag.")
    end
end
