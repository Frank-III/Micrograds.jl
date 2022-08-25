function make_moons(n_samples=1000, shuffle=true, noise=nothing, random_state=nothing)
    if isa(n_samples, Int)
        n_sample_out::Int = n_samples /2
        n_sample_in::Int = n_samples - n_sample_out
    else
        n_sample_out, n_sample_in = n_samples
    end
    outer_circ_x = cos.(range(0.,2*π,n_sample_out))
    outer_circ_y = sin.(range(0.,2*π,n_sample_out))
    inner_circ_x = 1 .- cos.(range(0,2*π,n_sample_in))
    inner_circ_y = 1 .- sin.(range(0,2*π,n_sample_in)) .- 0.5
    X = hcat([outer_circ_x..., inner_circ_x...], [outer_circ_y..., inner_circ_x...])
    y = vcat(zeros(n_sample_out), ones(n_sample_in))

    if shuffle
        idxs= randperm(n_samples)
        X, y = x[idxs,:], y[idxs]
    end
    # add noise
    X, y
end

make_moons(100)
