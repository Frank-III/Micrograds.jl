#=
micrograd:
- Julia version:
- Author: jiangda
- Date: 2022-08-19
=#
#using Parameters

module Micrograd

import Base.@kwdef
import Base.+, Base.*, Base.^, Base.-, Base./


export Value, +, -, ^, -, /, *, tanh, defaultVal

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

Value{R}(d::R, label::String, _children,op) where {R <: AbstractFloat} =
    Value{R}(data=d, label=label, _prev=_children, _op = op)

#show function

Base.show(io::IO, val::Value) = print(io, "Value(data=$(val.data))")



function +(v::Value, other::Value)
    out = Value{typeof(v.data)}(data = v.data + other.data, _prev = Set([v, other]), _op = "+")

    function _backward() v.grad += out.grad; other.grad += out.grad; end
    out._backward = _backward

    out
end

function *(v::Value, other::Value)
    out = Value{typeof(v.data)}(data = v.data * other.data, _prev = Set([v, other]), _op = "*")

    function _backward() v.grad += other.data * out.grad; other.grad += v.data * out.grad; end
    out._backward = _backward

    out
end

function tanh(v::Value)
    x = v.data
    t = (exp(2*x) - 1) / (exp(2*x) + 1)
    out = Value{typeof(x)}(data = t, _prev = Set(Value[v]),  _op="tanh")

    function _backward() v.grad = (1 - tÂ²) * out.grad; end
    out._backward = _backward

    out
end

function relu(v::Value)
end


end
