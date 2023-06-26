function get_mesh_name(data)
    check = check_element(data["Discretization"], "Input Mesh File")
    if !check
        @error "No mesh file is defined."
    end
    return data["Discretization"]["Input Mesh File"]
end

function get_topology_name(data)
    check = check_element(data["Discretization"], "Input FEM Topology File")
    topoFile::String = ""
    if check
        topoFile = data["Discretization"]["Input FEM Topology File"]
    end
    return check, topoFile
end

function get_bond_filter(data)
    check = check_element(data["Discretization"], "Bond Filters")
    bfList = Any
    if check
        bfList = data["Discretization"]["Bond Filters"]
    end
    return check, bfList
end