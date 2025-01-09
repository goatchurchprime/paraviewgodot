extends MeshInstance3D

var streamlinelength = 200
var streamlinerows = 3

var streamlinetextureimage : Image
var streamlinetexture : ImageTexture
var streamlinedata : PackedVector4Array
	
func _ready():
	streamlinedata.resize(streamlinelength*streamlinerows)
	var points = [ ]
	var scalars = [ ]
	for i in range(streamlinelength):
		points.push_back(Vector3((i-50)*0.05, sin(i*0.2)*0.3, cos(i*0.2)*0.3-1.3))
		scalars.push_back(sin(i*0.3)*2+3)
	setstreamlinedata(points, scalars)
	streamlinetextureimage = Image.create_from_data(streamlinelength, streamlinerows, false, Image.FORMAT_RGBAF, streamlinedata.to_byte_array())
	streamlinetexture = ImageTexture.create_from_image(streamlinetextureimage)
	mesh.material.set_shader_parameter("streamline", streamlinetexture)
	print(mesh.material.get_shader_parameter("streamline"))
	mesh.material.set_shader_parameter("streamlineYstretch", 0.5)
	assert (streamlinetexture != null)
	custom_aabb = AABB(Vector3(-10000,-10000,-10000), Vector3(20000,20000,20000))

const dvdgap = 2
func getp3(points, i):
	return Vector3(points[i][0], points[i][2], -points[i][1])

func setstreamlinedata(points, scalars):
	var Npts = min(streamlinelength, len(points))
	print(len(points), points[0], points[Npts-1])
	mesh.material.set_shader_parameter("streamlineYstretch", Npts*0.99/streamlinelength)
	for i in range(Npts):
		var p = getp3(points, i)
		var v = getp3(points, min(len(points)-1, i + dvdgap)) - getp3(points, max(0, i - dvdgap))
		var nvx = v.cross(Vector3(0,1,0)).normalized()
		var nvz = nvx.cross(v).normalized()
		streamlinedata.set(i, Vector4(p.x, p.y, p.z, scalars[i]))
		streamlinedata.set(i + streamlinelength, Vector4(nvx.x, nvx.y, nvx.z, scalars[i]))
		streamlinedata.set(i + 2*streamlinelength, Vector4(nvz.x, nvz.y, nvz.z, scalars[i]))

func setstreampoints(points, scalars):
	setstreamlinedata(points, scalars)
	streamlinetextureimage.set_data(streamlinelength, streamlinerows, false, Image.FORMAT_RGBAF, streamlinedata.to_byte_array())
	streamlinetexture.update(streamlinetextureimage)
	var Dp1 = Vector3(streamlinedata[10].x, streamlinedata[10].y, streamlinedata[10].z)
	var Dp2 = Vector3(streamlinedata[11].x, streamlinedata[11].y, streamlinedata[11].z)
	print("  . ", (Dp2 - Dp1).normalized() , streamlinedata[10+streamlinelength], streamlinedata[10+streamlinelength*2])
	visible = true
#	print($StartMarker.position)
	$StartMarker.position = getp3(points, 0)
	var Npts = min(streamlinelength, len(points))
	$EndMarker.position = getp3(points, Npts-1)
