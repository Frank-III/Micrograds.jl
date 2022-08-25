
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
    node_labels = map(x -> @sprintf("%.2f | %.2f", x.data, x.grad), collect(nodes))
    for (i,n) in enumerate(nodes)
        if !(isempty(n._op))
            node_idx[Symbol(hash(n),n._op)] = (len_nodes += 1)
            add_vertex!(dot)
            add_edge!(dot, len_nodes, i)
            push!(node_labels, "$(n._op)")
        end
	end

	for (n1,n2) in edges
		add_edge!(dot,node_idx[Symbol(hash(n1))],node_idx[Symbol(hash(n2), n2._op)])
	end
    #idx_node = Dict(value => key for (key, value) in node_idx)
    dot, node_labels
end

function drawgraph(root::Value)
    dot, node_labels = makegraph(root)
    plot(dot,node_labels, node_style="draw, rounded corners, fill=blue!10")
end
