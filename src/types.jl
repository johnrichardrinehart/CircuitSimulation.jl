struct TimeDomainData{Q,V}
    ts::AbstractArray{Q,1}
    vals::Vector{V}
    function TimeDomainData(t::AbstractArray{Q,1}, v::Vector{V}) where {Q<:Real,V<:Real}
        if length(t) !== length(v)
            error("Number of time points much match number of sampled values.")
        else
            new{Q,V}(t,v)
        end
    end
end

struct FrequencyDomainData{R,C}
    fs::AbstractArray{R,1}
    vals::Vector{C}
    function
        FrequencyDomainData(f::AbstractArray{R,1}, v::Vector{C}) where {R<:Real, C<:Complex}
        if length(f) !== length(v)
            error("Number of time points much match number of sampled values.")
        else
            new{R,C}(f,v)
        end
    end
end
