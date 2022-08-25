

@kwdef mutable struct Value{R<:AbstractFloat}
    data::R # for demonstration
    label::String = "" # could change to Symbol
    grad::R = 0.
    _backward::Function = () -> nothing
    _prev::Set{Value} = Set(Value[])
    _op = "" # could change to Symbol
end

const defaultVal = Value{Float64}

#constructor
Value{R}(d::R; label::String="", _children=Set(Value[]) ,op="") where {R <: AbstractFloat} =
    Value{R}(data=d, label=label, _prev=_children, _op = op)

Value{R}(d::R, label::String, _children, op) where {R <: AbstractFloat} =
    Value{R}(data=d, label=label, _prev=_children, _op = op)

#show function
Base.show(io::IO, val::Value) = print(io, "Value($(val.label),data=$(val.data))")

#some get Function
#@inline label(v::Value) = v.label

#@inline val(v::Value) = v.data

#@inline grad(v::Value) = v.grad



function +(v::Value, other::Value)
    out = Value{typeof(v.data)}(data = v.data + other.data, _prev = Set([v, other]), _op = "+")

    function _backward() v.grad += out.grad; other.grad += out.grad; end
    out._backward = _backward

    out
end
# how to dispatch on this?
function +(v::Value, other::Real)
    o = Value{typeof(v.data)}(other)
    v + o
end

+(v::Real, other::Value) = other + v



function *(v::Value, other::Value)
    out = Value{typeof(v.data)}(data = v.data * other.data, _prev = Set([v, other]), _op="*")

    function _backward() v.grad += other.data * out.grad; other.grad += v.data * out.grad; end
    out._backward = _backward

    out
end

function *(v::Value, other::Real)
    o = Value{typeof(v.data)}(other)
    v * o
end

*(v::Real, other::Value) = other * v

function -(v::Value, other::Value)
    v + Value{typeof(other.data)}(-1.) * other
end

function ^(v::Value, other::Real)
    out = Value{typeof(v.data)}(data= v.data^other, _prev= Set(Value[v]), _op="^($other)")

    function _backward() v.grad += (other * v.data^(other-1)) * out.grad; end
    out._backward = _backward

    out
end

function /(v::Value, other::Value)
    v * other^(-1)
end

function -(v::Value)
    v * (-1)
end

function tanh(v::Value)
    x = v.data
    t = (exp(2*x) - 1) / (exp(2*x) + 1)
    out = Value{typeof(x)}(data = t, _prev = Set(Value[v]),  _op="tanh")

    function _backward() v.grad += (1 - t^2) * out.grad; end
    out._backward = _backward

    out
end

function relu(v::Value)
    out = Value{typeof(v.data)}(data = max(0, v.data), _prev = Set(Value[v]), _op = "relu")

    function _backward() v.grad += (out.data > 0 ? out.grad : 0) ; end
    out._backward = _backward

    out
end

function backward(v::Value)
    topo = Value[]; visited = Set(Value[])
    function build_topo(v)
        if v ∉ visited
            push!(visited, v)
            for child in v._prev
                build_topo(child)
            end
            push!(topo, v)
        end
    end

    build_topo(v)

    v.grad = 1.
    for v in reverse(topo)
        v._backward()
    end
end
