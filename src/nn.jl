#to do: implement parameters function
abstract type Modules end

function zero_grad(x::Modules)
    setfield!.(parameters(x), :grad, 0.)
end

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
    out = relu(act)
    out
end

parameters(x::Neuron) = [x.w..., x.b]

Base.show(io::IO, x::Neuron) = print(io, (x.nonlin ? "relu" : "Linear"), " ", "Neuron($(length(x.w)))")

struct Layer <: Modules
    neurons
    function Layer(nin::Int,nout::Int; kwargs...)
        new([Neuron(nin; kwargs...) for _ in 1:nout])
    end
end

function (a::Layer)(x::AbstractVector)
    outs = (a.n).(x)
    length(outs) == 1 ? outs[1] : outs
end

parameters(x::Layer) = mapreduce(x->parameters(x),vcat,x.neurons)

Base.show(io::IO, x::Layer) = print(io, "Layer of [", join([repr(n) for n in x.neurons], ", "),"]")

struct MLP <: Modules
    layers::Vector{Layer}
    function MLP(nin, nout)
        sz = [nin, nout...]
        layers = [Layer(sz[i], sz[i+1]; nonlin=Bool(i !=length(nout))) for i in 1:length(nout)]
        new(layers)
    end
end

parameters(x::MLP) = mapreduce(x->parameters(x),vcat,x.layers)

Base.show(io::IO, x::MLP) = print(io, "MLP of [", join([repr(l) for l in x.layers], ", "), "]")

function (a::MLP)(x::AbstractVector)
    # for layer in a.layers
    #     x = layer(x)
    # end
    # x
    reduce((x,y) -> y(x), a.layers, init=x)
end
