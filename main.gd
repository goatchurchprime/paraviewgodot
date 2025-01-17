extends Node3D

func _ready():
	$XROrigin3D/XRAimRight/RadialMenu.menuitemtexts = [ 
		"ToggleNetworkView", 
		"GoOnline", 
		"Respawn",
		"Subtract1ms",
		"Add1ms",
		"Clearstreams" ]
	$XROrigin3D/XRAimRight/RadialMenu.menuitemselected.connect(_menuselected)

func _menuselected(menutext):
	if menutext == "ToggleNetworkView":
		$ViewportNetworkGateway.visible = not $ViewportNetworkGateway.visible
	elif menutext == "GoOnline":
		$ViewportNetworkGateway/Viewport/NetworkGateway.simple_webrtc_connect("paraviewroom")
	elif menutext == "Respawn":
		$XROrigin3D.position = Vector3(0,0,0)
	elif menutext == "Subtract1ms":
		$ParaviewStreamlines.updatestreamvelx(-1.0)
	elif menutext == "Add1ms":
		$ParaviewStreamlines.updatestreamvelx(1.0)
	elif menutext == "Clearstreams":
		for s in $ParaviewStreamlines/Streamlines.get_children():
			s.queue_free()
