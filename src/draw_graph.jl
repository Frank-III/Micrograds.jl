using Micrograds

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

function makegraph(root::Value)
	# shall use MetaGraphs?
	dot = DiGraph()
	nodes, edges = trace(root)
    len_nodes = length(nodes)
    node_idx = Dict{Symbol,Int64}(Symbol.(hash.(nodes)) .=> 1:len_nodes)
    add_vertices!(dot, len_nodes)
    for (i,n) in enumerate(nodes)
        if !(isempty(n._op))
            node_idx[Symbol(hash(n),n._op)] = (len_nodes += 1)
            add_vertex!(dot)
            add_edge!(dot, len_nodes, i)
        end
	end
    #for (n1,n2) in edges
    #    @show Symbol(hash(n1)) ∈ keys(node_idx)
    #    @show Symbol(hash(n2), n2._op) ∈ keys(node_idx)
    #end

	for (n1,n2) in edges
		add_edge!(dot,node_idx[Symbol(hash(n1))],node_idx[Symbol(hash(n2), n2._op)])
	end
    idx_node = Dict(value => key for (key, value) in node_idx)
    dot, idx_node
end

function drawgraph(root::Value)

end

function test()
	a = defaultVal(data = 2.0,label = "a")
	b = defaultVal(data = 1., label = "b")
	c = a + b; c.label = "c"
	e = defaultVal(data = 4., label = "e")
	d = c * e; d.label = "d"
	#@show d.data, d._backward, d._prev
	f = tanh(d)
    # nodes, edges = trace(f)
    # for n in nodes
    #     @show n, hash(n)
    # end
    # for (n1,n2) in edges
    #     @show n1, hash(n1)
    #     @show n2, hash(n2)
    # end
    #@show first(nodes), first(edges)
    #@show hash(first(nodes)), hash(first(edges)[1])
    g, ind_nodes = makegraph(f)
    @show collect(edges(g))
    @show collect(vertices(g))
    #@show d._op, a._op, b._op, c._op
    #backward(d)
    #@show  d.grad, e.grad, c.grad, a.grad, b.grad
end

test()
