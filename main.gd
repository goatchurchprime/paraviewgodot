extends Node3D

func _ready():
	$XROrigin3D/XRAimRight/RadialMenu.menuitemtexts = [ 
		"ToggleNetworkView", 
		"GoOnline" ]
	$XROrigin3D/XRAimRight/RadialMenu.menuitemselected.connect(_menuselected)

func _menuselected(menutext):
	if menutext == "ToggleNetworkView":
		$ViewportNetworkGateway.visible = not $ViewportNetworkGateway.visible
	elif menutext == "GoOnline":
		$ViewportNetworkGateway/Viewport/NetworkGateway.simple_webrtc_connect("paraviewroom")
