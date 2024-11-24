
# nix-shell -p python312Packages.paho-mqtt paraview
# run this file as as pvpython to serve the streamlines through mqtt

mqtthost = "mosquitto.doesliverpool.xyz"
#mqtthost = "localhost"
topicstreamdef = "paraview/streamdef"
topicstatus = "paraview/status"
topicstreamdata = "paraview/streamdata"
datadirectory = "/home/julian/data/timfreecad/CFD examples/case-smoothmesh-AL10"


import paho.mqtt.client as mqtt
import json

import paraview.simple as s

s.LoadState(datadirectory+"/view.pvsm", data_directory=datadirectory)
q = list(s.GetSources().values())[-1]
import paraview.servermanager as e
from vtkmodules.vtkCommonCore import vtkIdList



client = mqtt.Client("thing")

print("q.UpdatePipeline...")
q.UpdatePipeline()  # long wait
print("Done q.UpdatePipeline")

def transmitstreamlines(recid, a):
    indices = vtkIdList()
    cells = a.GetLines()
    cells.InitTraversal()
    lineno = 0
    while cells.GetNextCell(indices):
        ptids = [ indices.GetId(i)  for i in range(indices.GetNumberOfIds()) ]
        points = [ a.points.GetPoint(j)  for j in ptids ]
        scalars = [ a.point_data.scalars.GetValue(j)  for j in ptids ]
        jout = { "recid":recid, "lineno":lineno, "points":points, "scalars":scalars }
        lineno += 1
        print("transmitting on", topicstreamdata, "recid", recid, "lineno", lineno, "npts", len(points))
        client.publish(topicstreamdata, json.dumps(jout))


# mosquitto_pub -h '{"Point1":[-3.0,0.0,-1.6], "Point2":[3.0,1.0,-1.4]}'

def recstreamdef(v):
    print("recstreamdef ", v)
    if "Point1" in v:
        q.SeedType.Point1 = v["Point1"]
    if "Point2" in v:
        q.SeedType.Point2 = v["Point2"]
    recid = v.get("recid", 0)
    q.SeedType.Resolution = 5
    q.IntegrationDirection = "FORWARD"
    
    print("updating pipeline...")
    q.UpdatePipeline()  # long wait
    print(" done updating pipeline")
    a = e.Fetch(q)
    transmitstreamlines(recid, a)
        

def on_connect(client, userdata, flags, reason_code, properties=None):
    print(client, "CONNECTED")
    client.subscribe(topic=topicstreamdef)
    print("subscribed to", topicstreamdef)
    client.publish(topicstatus, "ready", retain=True)

client.on_connect = on_connect
def on_message(client, userdata, message, properties=None):
    if message.topic == "paraview/streamdef":
        try:
            recstreamdef(json.loads(message.payload))
        except json.JSONDecodeError as e:
            print("JSONDecodeError", e)
    else:
        print(" Received message " + str(message.payload) + " on topic '" + message.topic + "' with QoS " + str(message.qos))

client.will_set("paraview/status", retain=True)
client.on_message = on_message
print("Connecting to", mqtthost)
client.connect(mqtthost, port=1883, keepalive=60)
client.loop_forever()

"""
run paraview
Load State
select view.pvsm
use options search under specified directory
mess about and apply stream tracer
    
get MQTT interface going to listen and relate the streamlines as binary
-------------    
nix-shell -p python312Packages.paho-mqtt    
/nix/store/5s130y6qy7nkp7y640mlmcqffwzl5ww6-python3.12-paho-mqtt-1.6.1/lib/python3.12/site-packages/

sys.path.append("/nix/store/5s130y6qy7nkp7y640mlmcqffwzl5ww6-python3.12-paho-mqtt-1.6.1/lib/python3.12/site-packages/")
"""

