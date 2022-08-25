using Micrograds
using Test

@testset "Micrograds.jl" begin
    @testset "simple_grad" begin
        x = defaultVal(-4.)
        z = 2. * x + 2. + x
        q = relu(z) + z * x
        h = relu(z * z)
        y = h + q + q * x
        backward(y)
        @test y.data == -20.
        @test x.grad = -46.
    end

    @testset "more_op" begin
        a = defaultVal(-4.)
        b = defaultVal(2.)
    end
end

test()
