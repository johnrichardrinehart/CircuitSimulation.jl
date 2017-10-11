#__precompile__()
module CircuitSimulation
import DifferentialEquations
import QuadGK
import LsqFit
import Plots
import ForwardDiff

Plots.pyplot()

# Package utilities
include("types.jl")

# FFT Utilities
include("ifft_times.jl")
include("fft_freqs.jl")
include("fft.jl")
include("plot.jl")

# Time-domain response utilities
include("td_simulation.jl")

# Network parameter utilities
include("convert_params.jl")

# Transmission line frequency-domain utilities
include("tline_diffeq_solve.jl")
include("abcd_tline.jl")
include("tline_z.jl")

# Transmission line fitting utilities
include("liu_fit.jl")
include("lossy_fit.jl")

end # module
