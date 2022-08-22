#=
micrograd:
- Julia version:
- Author: jiangda
- Date: 2022-08-19
=#
#using Parameters

module Micrograds

import Base.@kwdef
import Base.+, Base.*, Base.^, Base.-, Base./, Base.tanh


export Value, defaultVal, backward, +, -, ^, -, /, *, tanh, relu

include("engine.jl")


end
