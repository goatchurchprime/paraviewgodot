extends MeshInstance3D

var streamlinelength = 200
var streamlinerows = 3

var streamlinetextureimage : Image
var streamlinetexture : ImageTexture
var streamlinedata : PackedVector4Array

func _ready():
	streamlinedata.resize(streamlinelength*streamlinerows)
	for i in range(streamlinelength):
		streamlinedata.set(i, Vector4((i-50)*0.05, sin(i*0.2)*0.3, cos(i*0.2)*0.3, 0.0))
		streamlinedata.set(i + streamlinelength, Vector4(0,1,0,i+80))
		streamlinedata.set(i + streamlinelength*2, Vector4(0,0,1,i+80))
		#streamlinedata.set(i + streamlinelength, Vector4(i,i+30,i+60,i+80))
	streamlinetextureimage = Image.create_from_data(streamlinelength, streamlinerows, false, Image.FORMAT_RGBAF, streamlinedata.to_byte_array())
	streamlinetexture = ImageTexture.create_from_image(streamlinetextureimage)
	mesh.material.set_shader_parameter("streamline", streamlinetexture)
	print(mesh.material.get_shader_parameter("streamline"))
	mesh.material.set_shader_parameter("streamlineYstretch", 0.5)
	assert (streamlinetexture != null)
	custom_aabb = AABB(Vector3(-1000,-1000,-1000), Vector3(1000,1000,1000))
	
const dvdgap = 2
func getp3(points, i):
	return Vector3(points[i][0], points[i][2], -points[i][1])

func setstreampoints(points, scalars):
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
		streamlinetextureimage.set_data(streamlinelength, streamlinerows, false, Image.FORMAT_RGBAF, streamlinedata.to_byte_array())
		streamlinetexture.update(streamlinetextureimage)
	var Dp1 = Vector3(streamlinedata[10].x, streamlinedata[10].y, streamlinedata[10].z)
	var Dp2 = Vector3(streamlinedata[11].x, streamlinedata[11].y, streamlinedata[11].z)
	print("  . ", (Dp2 - Dp1).normalized() , streamlinedata[10+streamlinelength], streamlinedata[10+streamlinelength*2])
	visible = true
#	print($StartMarker.position)
	$StartMarker.position = getp3(points, 0)
	$EndMarker.position = getp3(points, Npts-1)
