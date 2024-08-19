# SPDX-FileCopyrightText: 2023 Christian Willberg <christian.willberg@dlr.de>, Jan-Timo Hesse <jan-timo.hesse@dlr.de>
#
# SPDX-License-Identifier: BSD-3-Clause

module simple_additive
export compute_additive_model
export additive_name
export init_additive_model
"""
    additive_name()

Gives the additive name. It is needed for comparison with the yaml input deck.

# Arguments

# Returns
- `name::String`: The name of the additive model.

Example:
```julia
println(additive_name())
"additive Template"
```
"""
function additive_name()
    return "Simple"
end

"""
    compute_additive_model(datamanager, nodes, additive_parameter, time, dt)

Calculates the force densities of the additive. This template has to be copied, the file renamed and edited by the user to create a new additive. Additional files can be called from here using include and `import .any_module` or `using .any_module`. Make sure that you return the datamanager.

# Arguments
- `datamanager::Data_manager`: Datamanager.
- `nodes::Union{SubArray,Vector{Int64}}`: List of block nodes.
- `additive parameter::Dict(String, Any)`: Dictionary with additive parameter.
- `time::Float64`: The current time.
- `dt::Float64`: The current time step.
# Returns
- `datamanager::Data_manager`: Datamanager.
Example:
```julia
```
"""
function compute_additive_model(
    datamanager::Module,
    nodes::Union{SubArray,Vector{Int64}},
    additive_parameter::Dict,
    time::Float64,
    dt::Float64,
)

    nlist = datamanager.get_nlist()
    inverse_nlist = datamanager.get_inverse_nlist()
    activation_time = datamanager.get_field("Activation_Time")
    bond_damage = datamanager.get_bond_damage("NP1")
    active = datamanager.get_field("Active")
    heat_capacity = datamanager.get_field("Specific Heat Capacity")
    density = datamanager.get_field("Density")
    printTemperature = additive_parameter["Print Temperature"]
    # must be specified, because it might be that no temperature model has been defined
    flux = datamanager.get_field("Heat Flow", "NP1")
    ###########
    for iID in nodes
        if time - dt <= activation_time[iID] < time
            active[iID] = true
            flux[iID] = -printTemperature * heat_capacity[iID] * density[iID] ./ dt

            for (jID, neighborID) in enumerate(nlist[iID])
                if activation_time[neighborID] <= time && bond_damage[iID][jID] == 0
                    bond_damage[iID][jID] = 1.0
                    if haskey(inverse_nlist[neighborID], iID)
                        bond_damage[neighborID][inverse_nlist[neighborID][iID]] = 1.0
                    end
                end
            end
        end
    end

    return datamanager
end

"""
    init_additive_model(datamanager, nodes, additive_parameter)

Inits the simple additive model.

# Arguments
- `datamanager::Data_manager`: Datamanager.
- `nodes::Union{SubArray,Vector{Int64}}`: List of block nodes.
- `additive parameter::Dict(String, Any)`: Dictionary with additive parameter.
- `block::Int64`: The current block.
# Returns
- `datamanager::Data_manager`: Datamanager.

"""
function init_additive_model(
    datamanager::Module,
    nodes::Union{SubArray,Vector{Int64}},
    additive_parameter::Dict,
    block::Int64,
)

    return datamanager
end
end