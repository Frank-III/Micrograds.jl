using Micrograds

function test1()
    a = defaultVal(data = 2.0,label = "a")
	b = defaultVal(data = 1., label = "b")
	c = a + b; c.label = "c"
	e = defaultVal(data = 4., label = "e")
	d = c * e; d.label = "d";
    g = d^3
	#@show d.data, d._backward, d._prev
	f = relu(g)
    # nodes, edges = trace(f)
    #@show first(nodes), first(edges)
    #@show hash(first(nodes)), hash(first(edges)[1])
    drawgraph(f)
    backward(f)
    drawgraph(f)
    #@show node_labels
    #vertices(g)

    #@show d._op, a._op, b._op, c._op
    #backward(d)
    #@show  d.grad, e.grad, c.grad, a.grad, b.grad
end
test1()

function test2()
    x = defaultVal(-4.)
    z = 2. * x + 2. + x
    q = relu(z) + z * x
    h = relu(z * z)
    y = h + q + q * x
    backward(y)
    @show y.data, x.grad
end

test2()
