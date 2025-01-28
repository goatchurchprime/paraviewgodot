extends Node3D

func _ready():
	$XROrigin3D/XRAimRight/RadialMenu.menuitemselected.connect(_menuselected)

@onready var NetworkGateway = $ViewportNetworkGateway/Viewport/NetworkGateway

func getcontextmenutexts():
	var menuitemtexts = [ ]
	menuitemtexts.append("ToggleNetworkView")
	menuitemtexts.append("GoOnline" if NetworkGateway.simple_webrtc_status() == "unconnected" else "Disconnect")
	menuitemtexts.append("Respawn")
	menuitemtexts.append("ToggleVx")
	menuitemtexts.append("SetZeroAtXT")
	menuitemtexts.append("Clearstreams")
	menuitemtexts.append("ToggleZoom")
	return menuitemtexts

func _menuselected(menutext):
	if menutext == "ToggleNetworkView":
		$ViewportNetworkGateway.visible = not $ViewportNetworkGateway.visible
	elif menutext == "GoOnline":
		NetworkGateway.simple_webrtc_connect("paraviewroom")
	elif menutext == "Disconnect":
		NetworkGateway.simple_webrtc_connect(null)
	elif menutext == "Respawn":
		$XROrigin3D.position = Vector3(0,0,0)
	else:
		rpc("menuselected_act", menutext, $XROrigin3D/XRCamera3D.global_position.x)

func setstreamvelx(lx):
	$ParaviewStreamlines.streamvelx = lx
	for s in $ParaviewStreamlines/Streamlines.get_children():
		s.mat0.set_shader_parameter("streamvelx", lx)

@rpc("any_peer", "call_local", "reliable")
func menuselected_act(menutext, headx):
	if menutext == "ToggleVx":
		var lstreamvelx = -12.516 if $ParaviewStreamlines.streamvelx == 0.0 else 0.0
		var t = get_tree().create_tween().tween_method(setstreamvelx, $ParaviewStreamlines.streamvelx, lstreamvelx, 0.3).set_ease(Tween.EASE_OUT)
		#$ParaviewStreamlines.updatestreamvelx(lstreamvelx, $ParaviewStreamlines.zerox)
	elif menutext == "SetZeroAtXT":
		$ParaviewStreamlines.updatestreamvelx($ParaviewStreamlines.streamvelx, headx)
	elif menutext == "ToggleZoom":
		if $ParaviewStreamlines.utimespeed == 0.5:
			$ParaviewStreamlines.utimespeed = 1.0
			$ParaviewStreamlines.utimefac = 0.5
			$ParaviewStreamlines.stripecancel = 0.1
		else:
			$ParaviewStreamlines.utimespeed = 0.5
			$ParaviewStreamlines.utimefac = 12.0
			$ParaviewStreamlines.stripecancel = 1.0
		$ParaviewStreamlines.updatestreamvelx($ParaviewStreamlines.streamvelx, $ParaviewStreamlines.zerox)
	elif menutext == "Clearstreams":
		for s in $ParaviewStreamlines/Streamlines.get_children():
			s.queue_free()
