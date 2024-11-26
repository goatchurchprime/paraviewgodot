
# nix-shell -p paraview python312Packages.pygltflib python312Packages.numpy
import numpy as np
import pygltflib

if 0:

    import paraview.simple as s
    import paraview.servermanager as e
    from vtk.util import numpy_support
    from vtkmodules.vtkCommonCore import vtkIdList

    datadirectory = "/home/julian/data/timfreecad/CFD examples/case-smoothmesh-AL10"

    def getsource(s, name):
        for k, v in s.GetSources().items():
            if k[0] == name:
                return v
                

    s.LoadState(datadirectory+"/view1.pvsm", data_directory=datadirectory)
    svalues = list(s.GetSources().values())
    print(svalues)
    q = getsource(s, "StreamTracer1")
    l = getsource(s, "CleantoGrid1")
    c = getsource(s, "Contour1")
    c.UpdatePipeline()
    ec = e.Fetch(c)

# l = svalues[0]  # OpenFoamReader

    print(l)  # vtk
    l.UpdatePipeline()
    b = e.Fetch(l)  # vtkMultiBlockDataset
    g = b.GetBlock(0) # vtkUnstructuredGrid

    h = numpy_support.vtk_to_numpy(g.points.GetData())
    p = g.GetPolyhedronFaces()

    hf = numpy_support.vtk_to_numpy(p.GetData())
    hi = numpy_support.vtk_to_numpy(p.offsets_array)
    hc = numpy_support.vtk_to_numpy(p.connectivity_array)


    i = 0
    Ntri = 0
    while i < len(hf):
        for j in range(2, hf[i]):
            Ntri += 1
        i += hf[i] + 1

    points = h
    triangles = np.zeros((Ntri,3), dtype="uint32")

    i = 0
    Ntri = 0
    while i < 1000: # len(hf):
        for j in range(2, hf[i]):
            triangles[Ntri] = [hf[i+1], hf[i+j], hf[i+j+1]]
            Ntri += 1
        i += hf[i] + 1

    print(points.shape, triangles.shape, points.dtype)

else:
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

triangles_binary_blob = triangles.flatten().tobytes()
points_binary_blob = points.tobytes()
gltf = pygltflib.GLTF2(
    scene=0,
    scenes=[pygltflib.Scene(nodes=[0])],
    nodes=[pygltflib.Node(mesh=0)],
    meshes=[
        pygltflib.Mesh(
            primitives=[
                pygltflib.Primitive(
                    attributes=pygltflib.Attributes(POSITION=1), indices=0
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
    ],
    buffers=[
        pygltflib.Buffer(
            byteLength=len(triangles_binary_blob) + len(points_binary_blob)
        )
    ],
)
gltf.set_binary_blob(triangles_binary_blob + points_binary_blob)
glb = b"".join(gltf.save_to_bytes())  # save_to_bytes returns an array of the components of a glb
open("ghgh.glb", "wb").write(glb)

