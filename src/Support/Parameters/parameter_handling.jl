include("./parameter_mesh_handling.jl")
include("./parameter_handling_blocks.jl")
function check_element(data, key)
    return haskey(data, key)
end