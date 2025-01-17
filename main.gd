extends Node3D

func _ready():
	$XROrigin3D/XRAimRight/RadialMenu.menuitemtexts = [ 
		"ToggleNetworkView", 
		"GoOnline", 
		"Respawn",
		"ToggleVx",
		"SetZeroAtXT",
		"Clearstreams", 
		"ToggleZoom" ]
	$XROrigin3D/XRAimRight/RadialMenu.menuitemselected.connect(_menuselected)


func _menuselected(menutext):
	if menutext == "ToggleNetworkView":
		$ViewportNetworkGateway.visible = not $ViewportNetworkGateway.visible
	elif menutext == "GoOnline":
		$ViewportNetworkGateway/Viewport/NetworkGateway.simple_webrtc_connect("paraviewroom")
	elif menutext == "Respawn":
		$XROrigin3D.position = Vector3(0,0,0)
	else:
		rpc("menuselected_act", menutext, $XROrigin3D/XRCamera3D.global_position.x)

@rpc("any_peer", "call_local", "reliable")
func menuselected_act(menutext, headx):
	if menutext == "ToggleVx":
		$ParaviewStreamlines.updatestreamvelx(-12.516 if $ParaviewStreamlines.streamvelx == 0.0 else 0.0, $ParaviewStreamlines.zerox)
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
