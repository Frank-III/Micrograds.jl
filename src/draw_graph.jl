using Micrograd

using Graphs, MetaGraphs

function trace(root::Value)
	# builds a set of all nodes and edges in a graph
  nodes, edges = Set(Value[]), Set(Tuple{Value,Value}[])
  function build(v::Value)
    if v ∉ nodes
      push!(nodes,v)
      for child ∈ v._prev
        push!(edges,(child, v))
        build(child)
			end
		end
	end
  build(root)
  nodes, edges
end

function draw_dot(root::Value)
	# shall use MetaGraphs?
	dot = DiGraph()
	nodes, edges = trace(root)
	for n in nodes

	end

	for (n1,n2) in edges
		add_edge!(dot,n1,n2)
	end
end

function test()
	a = defaultVal(data = 2.0,label = "a")
	b = defaultVal(data = 1., label = "b")
	c = a + b; c.label = "c"
	@show c.data, c._backward, c._prev
	e = defaultVal(data = 4., label = "e")
	d = c * e
	#@show d.data, d._backward, d._prev
	trace(d)
end

test()
