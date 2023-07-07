
module Data_manager
include("./Parameters/parameter_handling.jl")
#export nnodes
#export nbonds
export set_nnodes
export get_nnodes
export set_nbonds
export get_nbonds
export create_node_field
export create_constant_node_field
export create_bond_field
export create_constant_bond_field
##########################
# Variables
##########################
nnodes = Ref(0)
nbonds = Ref(0)
fieldnames = Dict(Int64 => Dict(), Float32 => Dict(), Bool => Dict())
##########################


function set_nnodes(n)
    global nnodes = n
end
function get_nnodes()
    return nnodes
end

function set_nbonds(n)
    global nbonds = n
end
function get_nbonds()
    return nbonds
end
function create_node_field(name::String, type::DataType, dof::Int64)
    return create_field(name, type, "Node", dof, true)
end
function create_constant_node_field(name::String, type::DataType, dof::Int64)
    return create_field(name, type, "Node", dof, false)
end
function create_bond_field(name::String, type::DataType, dof::Int64)
    return create_field(name, type, "Bond", dof, true)
end
function create_constant_bond_field(name::String, type::DataType, dof::Int64)
    return create_field(name, type, "Bond", dof, false)
end
# wenn nicht existiert, wird an den gesamtvector der Teil angehängt. Dann wird der Vectorabschnitt zurückgeschickt und ist in der jeweiligen routine nutzbar
# bisher wird alles synchrononisiert
# nicht synchronisierte vectoren brauchen nicht hier rein -> Problem ist, wie mit der synch Option zu verfahren ist (eine stelle synch andere non synch)Was zählt?
# besser ist vielleicht einen synchmanager zu bauen -> dort kann man sich eintragen

function create_field(name::String, vartyp::DataType, bondNode::String, dof::Int64, time_dependend::Bool)

    if !haskey(fieldnames, type)
        fieldnames[vartyp] = Dict()
    end
    if haskey(fieldnames[vartyp], name)
        return fieldnames[vartyp][name]
    else
        len = field_length(bondNode, time_dependend) * dof

        if length(values(fieldnames[vartyp])) == 0
            num = 0
        else
            # start ende -> alles in einen Vector, dann sind weniger synchros nötig
            num = maximum(values(fieldnames[vartyp]))[2]
            fieldnames[type][name] = (num + 1, num + len + 1)
        end
        return fieldnames[vartyp][name]
    end
end

function field_length(bondNode::String, time_dependend::Bool)
    le = 0
    if bondNode == "Bond"
        le = Parameter_Handling.nbonds
    elseif bondNode == "Node"
        le = Parameter_Handling.nnodes
    else
        le = 0
        @error "Not supported option $bondNode allowed options are Bond::String or Node::String"
    end
    if time_dependend
        le *= 2
    end
    return le
end
function key_magic(name::String, type, bondNode::String, dof::Int64, time_dependend::Bool)

    #integer liste wo die keys geführt werden -> nötig?
end

function get_field(name::String)
end

function synch_manager()
    # Liste mit den Daten die synchronisiert werden sollen -> 
    # upload; für init
    # download sum; für time int
    # down - up für bond information
end
end