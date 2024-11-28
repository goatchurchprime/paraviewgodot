
# nix-shell -p paraview python312Packages.pygltflib python312Packages.numpy
import numpy as np
import pygltflib

if 1:
    glbfilename = "decimatedwing.glb"

    import numpy as np
    import pygltflib
    import paraview.simple as s
    import paraview.servermanager as e
    from vtk.util import numpy_support
    from vtkmodules.vtkCommonCore import vtkIdList

    datadirectory = "/home/julian/data/timfreecad/CFD examples/case-smoothmesh-AL10"

    def getsource(s, name):
        for k, v in s.GetSources().items():
            if k[0] == name:
                return v

    # same as before, but with a contour component added
    s.LoadState(datadirectory+"/view1.pvsm", data_directory=datadirectory)
    svalues = list(s.GetSources().items())
    print(svalues)
    q = getsource(s, "StreamTracer1")
    l = getsource(s, "CleantoGrid1")
    c = getsource(s, "Decimate1")
    c.UpdatePipeline()
    ec = e.Fetch(c)


    p = ec.GetBlock(0)
    pp = numpy_support.vtk_to_numpy(p.GetPoints().GetData())
    pf = numpy_support.vtk_to_numpy(p.GetPolys().GetData())
    pn = numpy_support.vtk_to_numpy(p.point_data.normals)
    #ps = numpy_support.vtk_to_numpy(p.point_data.scalars) # all 500.0
    ps = numpy_support.vtk_to_numpy(p.point_data.vectors) # all 500.0

    i = 0
    Ntri = 0
    while i < len(pf):
        for j in range(2, pf[i]):
            Ntri += 1
        i += pf[i] + 1

    points = pp
    normals = pn
    triangles = np.zeros((Ntri,3), dtype="uint32")
    vertex_colors = ps

    i = 0
    Ntri = 0
    while i < len(pf):
        for j in range(2, pf[i]):
            triangles[Ntri] = [pf[i+1], pf[i+j], pf[i+j+1]]
            Ntri += 1
        i += pf[i] + 1

    print(points.shape, triangles.shape, points.dtype)

else:
    glbfilename = "cube.glb"
    points = np.array(
        [
            [-0.5, -0.5, 0.5],
            [0.5, -0.5, 0.5],
            [-0.5, 0.5, 0.5],
            [0.5, 0.5, 0.5],
            [0.5, -0.5, -0.5],
            [-0.5, -0.5, -0.5],
            [0.5, 0.5, -0.5],
            [-0.5, 0.5, -0.5],
        ],
        dtype="float32",
    )
    pl = np.sqrt(sum(points[0]*points[0]))
    normals = points/pl
    triangles = np.array(
        [
            [0, 1, 2],
            [3, 2, 1],
            [1, 0, 4],
            [5, 4, 0],
            [3, 1, 6],
            [4, 6, 1],
            [2, 3, 7],
            [6, 7, 3],
            [0, 2, 5],
            [7, 5, 2],
            [5, 7, 4],
            [6, 4, 7],
        ],
        dtype="uint32",
    )
    vertex_colors = points*2

triangles_binary_blob = triangles.flatten().tobytes()
points_binary_blob = points.tobytes()
normals_binary_blob = normals.tobytes()
vertex_colors_binary_blob = vertex_colors.tobytes()

gltf = pygltflib.GLTF2(
    scene=0,
    scenes=[pygltflib.Scene(nodes=[0])],
    nodes=[pygltflib.Node(mesh=0)],
    meshes=[
        pygltflib.Mesh(
            primitives=[
                pygltflib.Primitive(
                    attributes=pygltflib.Attributes(POSITION=1, NORMAL=2, COLOR_0=3), indices=0
                )
            ]
        )
    ],
    accessors=[
        pygltflib.Accessor(
            bufferView=0,
            componentType=pygltflib.UNSIGNED_INT,
            count=triangles.size,
            type=pygltflib.SCALAR,
            max=[int(triangles.max())],
            min=[int(triangles.min())],
        ),
        pygltflib.Accessor(
            bufferView=1,
            componentType=pygltflib.FLOAT,
            count=len(points),
            type=pygltflib.VEC3,
            max=points.max(axis=0).tolist(),
            min=points.min(axis=0).tolist(),
        ),
        pygltflib.Accessor(
            bufferView=2,
            componentType=pygltflib.FLOAT,
            count=len(points),
            type=pygltflib.VEC3,
            max=normals.max(axis=0).tolist(),
            min=normals.min(axis=0).tolist(),
        ),
        pygltflib.Accessor(
            bufferView=3,
            componentType=pygltflib.FLOAT,
            count=len(points),
            type=pygltflib.VEC3,
            max=vertex_colors.max(axis=0).tolist(),
            min=vertex_colors.min(axis=0).tolist(),
        ),
    ],
    bufferViews=[
        pygltflib.BufferView(
            buffer=0,
            byteLength=len(triangles_binary_blob),
            target=pygltflib.ELEMENT_ARRAY_BUFFER,
        ),
        pygltflib.BufferView(
            buffer=0,
            byteOffset=len(triangles_binary_blob),
            byteLength=len(points_binary_blob),
            target=pygltflib.ARRAY_BUFFER,
        ),
        pygltflib.BufferView(
            buffer=0,
            byteOffset=len(triangles_binary_blob)+len(points_binary_blob),
            byteLength=len(normals_binary_blob),
            target=pygltflib.ARRAY_BUFFER,
        ),
        pygltflib.BufferView(
            buffer=0,
            byteOffset=len(triangles_binary_blob)+len(points_binary_blob)+len(normals_binary_blob),
            byteLength=len(vertex_colors_binary_blob),
            target=pygltflib.ARRAY_BUFFER,
        ),
    ],
    buffers=[
        pygltflib.Buffer(
            byteLength=len(triangles_binary_blob) + len(points_binary_blob) + len(normals_binary_blob) + len(vertex_colors_binary_blob)
        )
    ],
)
gltf.set_binary_blob(triangles_binary_blob + points_binary_blob + normals_binary_blob + vertex_colors_binary_blob)
glb = b"".join(gltf.save_to_bytes())  # save_to_bytes returns an array of the components of a glb
open(glbfilename, "wb").write(glb)

#create_from_arrays(arrays: Array, primitive_type: Mesh.PrimitiveType = 3)
#Creates this SurfaceTool from existing vertex arrays such as returned by commit_to_arrays(), Mesh.surface_get_arrays(),
