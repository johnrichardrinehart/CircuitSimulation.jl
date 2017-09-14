#__precompile__()
module CircuitSimulation
import DifferentialEquations
import QuadGK
import LsqFit
import Plots

Plots.pyplot()

include("tline.jl")
include("convert_params.jl")
include("abcd.jl")
include("liu_fit.jl")
include("lossy_fit.jl")
include("fft_with_units.jl")
include("td_simulation.jl")
include("types.jl")
include("plot.jl")

export telegrapherxi
export tline_solve
export abcd2s
export abcd_tline
export TimeData
end # module
