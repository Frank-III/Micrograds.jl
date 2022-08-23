
abstract type Modules end

struct Neuron <: Modules
    w
    b
    nonlin::Bool
    function Neuron(nin::Int; nonlin=true)
        w = [defaultVal(rand()) for _ in 1:nin]
        b = defaultVal(rand())
        new(w, b, true)
    end
end

function (a::Neuron)(x::AbstractVector)
    x = (eltype(x) <: Value) ? x : Value{eltype(x)}.(x)
    act = sum(a.w .* x) + a.b
    out = tanh(act)
    out
end

struct Layer <: Modules
    neurons
    function Layer(nin::Int,nout::Int)
        new([Neurons(nin) for _ in nout])
    end
end

function (a::Layer)(x::AbstractVector)
    outs = (a.n).(x)
    length(outs) == 1 ? outs[1] : outs
end
