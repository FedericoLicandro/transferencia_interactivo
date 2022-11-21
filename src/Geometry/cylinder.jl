
export create_cylinder

function create_cylinder(r,L;n = 100)
  
    gmsh.initialize()
    gmsh.model.add("cylinder")
    lc = min(r,L)/10
    
    gmsh.model.geo.addPoint( 0, 0, 0, lc, 1 )
    gmsh.model.geo.addPoint(-r, 0, 0, lc, 2 )
    gmsh.model.geo.addPoint( 0, r, 0, lc, 3 )
    gmsh.model.geo.addPoint( r, 0, 0, lc, 4 )
    gmsh.model.geo.addPoint( 0,-r, 0, lc, 5 )

    gmsh.model.geo.addCircleArc(2,1,3,1)
    gmsh.model.geo.addCircleArc(3,1,4,2)
    gmsh.model.geo.addCircleArc(4,1,5,3)
    gmsh.model.geo.addCircleArc(5,1,2,4)

    gmsh.model.geo.addCurveLoop([1, 2, 3, 4], 1)
    gmsh.model.geo.addPlaneSurface([1], 1)
    gmsh.model.addPhysicalGroup(1,[1, 2, 3, 4],5)
    gmsh.model.setPhysicalName(1,5,"circunferencia1")
    gmsh.model.addPhysicalGroup(2,[1],2)
    gmsh.model.setPhysicalName(2,2,"circulo")

    ov = gmsh.model.geo.extrude([(2, 1)], 0, 0, L, [n], [1])
   

    gmsh.model.addPhysicalGroup(3,[ov[2][2]],102)
    gmsh.model.addPhysicalGroup(1,[7, 8, 9, 10],100)
    gmsh.model.setPhysicalName(1,100,"circunferencia2")

    gmsh.model.addPhysicalGroup(2,[ov[1][2]],103)
    gmsh.model.setPhysicalName(2,103,"circulo2")
    gmsh.model.addPhysicalGroup(2,[14,18,22,26],101)
    gmsh.model.setPhysicalName(2,101,"cilindro")

    gmsh.model.geo.synchronize()
    gmsh.model.mesh.generate(3)

    gmsh.write("cylinder.msh")


    gmsh.finalize()


    model = GmshDiscreteModel("cylinder.msh")
    fn = "cylinder.json"
    to_json_file(model,fn)
    geo = DiscreteModelFromFile("cylinder.json")
    return geo
end

