function test()
	a = defaultVal(data = 2.0,label = "a")
	b = defaultVal(data = 1., label = "b")
	c = a + b; c.label = "c"
	e = defaultVal(data = 4., label = "e")
	d = c * e; d.label = "d"
	#@show d.data, d._backward, d._prev
	f = tanh(d)
    # nodes, edges = trace(f)
    #@show first(nodes), first(edges)
    #@show hash(first(nodes)), hash(first(edges)[1])
    drawgraph(f)
    #@show node_labels
    #vertices(g)

    #@show d._op, a._op, b._op, c._op
    #backward(d)
    #@show  d.grad, e.grad, c.grad, a.grad, b.grad
end

test()
