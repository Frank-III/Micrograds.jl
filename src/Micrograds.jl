#=
micrograd:
- Julia version:
- Author: jiangda
- Date: 2022-08-19
=#

module Micrograds

using Random, Graphs, GraphPlot, Printf
import Base.@kwdef
import Base.+, Base.*, Base.^, Base.-, Base./, Base.tanh


export Value, defaultVal, backward, +, -, ^, -, /, *, tanh, relu, trace, drawgraph

include("engine.jl")
include("draw_graph.jl")
include("nn.jl")

end
