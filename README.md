# Micrograd.jl(WIP)

A Julia implementation of Andrej's [micrograd](https://github.com/karpathy/micrograd) python package.

## Example 
### use of simple autograd engine
```Julia
using Micrograds
defaultVal = Value{Float64}
a = defaultVal(data = 2.0,label = "a")
b = defaultVal(data = 1., label = "b")
c = a + b; c.label = "c"
e = defaultVal(data = 4., label = "e")
d = c * e; d.label = "d"
f = tanh(d)
drawgraph(f)
```
![simple_graph](./simple_graph.svg)

### use simple `nn` engine to train batched data
todo
