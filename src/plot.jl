function Plots.plot(d::CircuitSimulation.TimeData)
    Plots.plot(fftshift(d.ts),fftshift(d.vals))
end

function Plots.plot(d::FrequencyData)
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
                   yaxis="Amplitude",
                   label="",
                   size=(1200,800),
                  )
    Plots.plot!(b,fftshift(d.fs)*scale[1],fftshift(real(d.vals)))
end
