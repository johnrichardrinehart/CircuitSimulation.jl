struct TimeData{Q}
    ts::Vector{Q}
    vals::Vector{Q}
    function TimeData(t::Vector{Q}, v::Vector{Q}) where {Q<:Real}
        if length(t) !== length(v)
            error("Number of time points much match number of sampled values.")
        else
            new{Q}(t,v)
        end
    end
end

struct FrequencyData{Q,C}
    fs::Vector{Q}
    vals::Vector{C}
    function FrequencyData(f::Vector{Q}, v::Vector{C}) where {Q<:Real, C<:Complex}
        if length(f) !== length(v)
            error("Number of time points much match number of sampled values.")
        else
            new{Q,C}(f,v)
        end
    end
end
