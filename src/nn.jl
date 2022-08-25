
abstract type Modules end

struct Neuron <: Modules
    w
    b
    nonlin::Bool
    function Neuron(nin::Int; nonlin=true)
        w = [defaultVal(rand()) for _ in 1:nin]
        b = defaultVal(rand())
        new(w, b, nonlin)
    end
end

function (a::Neuron)(x::AbstractVector)
    x = (eltype(x) <: Value) ? x : Value{eltype(x)}.(x)
    act = sum(a.w .* x; init=a.b)
    out = tanh(act)
    out
end

struct Layer <: Modules
    neurons::Vector{Neuron}
    function Layer(nin::Int,nout::Int; kwargs...)
        new([Neurons(nin; kwargs) for _ in nout])
    end
end

function (a::Layer)(x::AbstractVector)
    outs = (a.n).(x)
    length(outs) == 1 ? outs[1] : outs
end

struct MLP <: Modules
    layers::Vector{Layer}
    function MLP(nin, nout)
        sz = [nin, nout...]
        layers = [Layer(sz[i], sz[i+1]; nonlin=(i !=length(nout))) for i in 1:length(nout)]
        new(layers)
    end
end

function (a::MLP)(x::AbstractVector)
    # for layer in a.layers
    #     x = layer(x)
    # end
    # x
    reduce((x,y) -> y(x), a.layers, init=x)
end
