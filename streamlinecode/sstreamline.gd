extends Node3D

func rotyuppoints(points):
	var res = [ ]
	for pt in points:
		res.push_back(Vector3(pt[0], pt[2], -pt[1]))
	return res

const dvdgap = 2
func getp3(points, i):
	return Vector3(points[i][0], points[i][2], -points[i][1])

@onready var mat0 = $Stream.get_surface_override_material(0)
var streamtimeoffset0 = 0.0
var xtarray = [ ]

func maketubesstreammesh(points, integrationtime, U):
	print(mat0)
	var ncircp = 5
	var tlo = integrationtime[0] - 0.1
	var thi = integrationtime[-1] + 0.1
	prints("integrationtime", tlo, thi, (getp3(points,1) - getp3(points,0)).length()/(integrationtime[1] - integrationtime[0]))
	# integrationtime = UV.x*streamtimetimefac + streamtimeoffset;
	streamtimeoffset0 = tlo
	var streamtimetimefac = thi - tlo;
	# integrationtime = UV.x*streamtimetimefac + streamtimeoffset;

	var Npts = len(points)
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(Npts):
		var p = getp3(points, i)
		xtarray.push_back(Vector2(p.x, integrationtime[i]))
		var v = getp3(points, min(len(points)-1, i + dvdgap)) - getp3(points, max(0, i - dvdgap))
		var nvx = v.cross(Vector3(0,1,0)).normalized()
		var nvz = -nvx.cross(v).normalized()
		var lu = (integrationtime[i] - streamtimeoffset0)/streamtimetimefac
		var plv = U[i]
		for j in range(ncircp):
			var lv = (j - i*0.0)/ncircp
			var th = deg_to_rad(lv*360 + 20)
			var cth = cos(th)
			var sth = sin(th)
			var pr = nvx*cth + nvz*sth
			st.set_normal(pr)
			st.set_uv(Vector2(lu, plv))
			st.add_vertex(p + pr*0.0)
	
		if i != 0:
			for j in range(ncircp):
				var i0j0 = (i - 1)*ncircp + j
				var i1j0 = i*ncircp + j
				var j1 = j + 1 if j != ncircp - 1 else 0
				var i0j1 = (i - 1)*ncircp + j1
				var i1j1 = i*ncircp + j1
				st.add_index(i0j0)
				st.add_index(i1j0)
				st.add_index(i1j1)
				st.add_index(i0j0)
				st.add_index(i1j1)
				st.add_index(i0j1)
	$Stream.mesh = st.commit()
	#print($Stream.mesh.surface_get_arrays(0)[Mesh.ARRAY_INDEX])
	mat0 = $Stream.get_surface_override_material(0)
	mat0.set_shader_parameter("streamtimetimefac", streamtimetimefac)
	mat0.set_shader_parameter("streamtimeoffset", streamtimeoffset0)

	
func setvelocityaddedinx(streamvelx, zerox, utimespeed, utimefac, stripecancel):
	mat0.set_shader_parameter("streamvelx", streamvelx)
	# setzeroatxt(zerox) 
	var i0 = 0
	var i1 = len(xtarray) - 1
	while i1 > i0 + 1:
		var im = int((i1 + i0)/2)
		assert (im != i0 and im != i1)
		if xtarray[im].x < zerox:
			i0 = im
		else:
			i1 = im
	var lam = inverse_lerp(xtarray[i0].x, xtarray[i1].x, zerox)
	var t00 = lerp(xtarray[i0].y, xtarray[i1].y, clamp(lam, 0.0, 1.0))
	mat0.set_shader_parameter("streamtimeoffset", streamtimeoffset0 - t00)
	mat0.set_shader_parameter("utimespeed", utimespeed)
	mat0.set_shader_parameter("utimefac", utimefac)
	mat0.set_shader_parameter("stripecancel", stripecancel)

func makepointsstreammesh(lpoints, scalars):
	var points = rotyuppoints(lpoints)
	var Npts = len(points)
	var st = SurfaceTool.new()
	var u = 0.0
	st.begin(Mesh.PRIMITIVE_POINTS)
	st.set_material($Stream.mesh.material)
	for i in range(Npts):
		st.set_uv(Vector2(u/700, 0))
		st.add_vertex(points[i])
		u += scalars[i]
		prints(i, u, scalars[i])
	$Stream.mesh = st.commit()
