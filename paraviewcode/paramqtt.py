
# to serve the streamlines through mqtt:
#   nix-shell -p python312Packages.paho-mqtt paraview python312Packages.paho-mqtt
#   pvpython paramqtt.py 

mqtthost = "mosquitto.doesliverpool.xyz"
#mqtthost = "localhost"
topicstreamdef = "paraview/streamdef"
topicstatus = "paraview/status"
topicstreampredata = "paraview/streampredata"
topicstreamdata = "paraview/streamdata"

#datadirectory = "/home/julian/data/timfreecad/CFD examples/case-smoothmesh-AL10"
datadirectory = "../paraviewdata/case-smoothmesh-AL10"
statefile = "view2.pvsm"
transmitsteamlinesfile = "../paraviewdata/laststreamlines.txt"

import json, os
        
        
#jstreamlines = json.load(open(transmitsteamlinesfile, "r"))
#jstreamlines = mergestreamlines(jstreamlines)
#print(jstreamlines[-1]["IntegrationTime"])
#exit()


import paho.mqtt.client as mqtt
import paraview.simple as s

s.LoadState(os.path.join(datadirectory, statefile), data_directory=datadirectory)
q = list(s.GetSources().values())[-1]
import paraview.servermanager as e
from vtkmodules.vtkCommonCore import vtkIdList



"""
q.SeedType.Point1 = pt1
q.SeedType.Point2 = pt2

q.IntegrationDirection = "BOTH"
q.SeedType.Resolution = 1
q.UpdatePipeline()  # long wait
a = e.Fetch(q)
    
indices = vtkIdList()
cells = a.GetLines()
cells.InitTraversal()
ss = [ ]
ssp = [ ]
while cells.GetNextCell(indices):
    ptids = [ indices.GetId(i)  for i in range(indices.GetNumberOfIds()) ]
    points = [ a.points.GetPoint(j)  for j in ptids ]
    print("ptids ", ptids[0], ptids[-1])
    k = "IntegrationTime"
    a.point_data.SetActiveScalars(k)
    scalars = [ a.point_data.scalars.GetValue(j)  for j in ptids ]
    ss.append(scalars)
    ssp.append(points)
"""


client = mqtt.Client("thing")

print("q.UpdatePipeline...")
q.UpdatePipeline()  # long wait
print("Done q.UpdatePipeline")
# q.PointData.items()  [('AngularVelocity', Array: AngularVelocity), ('IntegrationTime', Array: IntegrationTime), ('k', Array: k), ('Normals', Array: Normals), ('nut', Array: nut), ('omega', Array: omega), ('p', Array: p), ('Rotation', Array: Rotation), ('U', Array: U), ('Vorticity', Array: Vorticity)]
# a = e.Fetch(q)
# a.point_data.SetActiveScalars("IntegrationTime")   "p" is the default
# a.point_data.scalars.GetValue(100)

def extractstreamlines(recid, a, bnegy):
    indices = vtkIdList()
    cells = a.GetLines()
    jstreamlines = [ ]
    
    # could get at the arrays directly without the iterator stuff like:
    #numpy.asarray(cells.data)
    #numpy.asarray(cells.offsets_array)

    cells.InitTraversal()
    lineno = 0
    def fnegy(p):
        return (p[0], -p[1] if bnegy else p[1], p[2])
    while cells.GetNextCell(indices):
        ptids = [ indices.GetId(i)  for i in range(indices.GetNumberOfIds()) ]
        points = [ fnegy(a.points.GetPoint(j))  for j in ptids ]
        jout = { "recid":recid, "lineno":lineno, "points":points }
        for k in ["IntegrationTime", "p"]:
            a.point_data.SetActiveScalars(k)
            scalars = [ a.point_data.scalars.GetValue(j)  for j in ptids ]
            jout[k] = scalars
        for k in ["U"]:
            a.point_data.SetActiveVectors(k)
            assert a.point_data.vectors.number_of_components == 3
            vecs = [ a.point_data.vectors.GetTuple3(j)  for j in ptids ]
            jout[k] = vecs
        
        print("extracting for", topicstreamdata, "recid", recid, "lineno", lineno, "npts", len(points))
        jstreamlines.append(jout)
        lineno += 1

    if transmitsteamlinesfile:
        print("saving", transmitsteamlinesfile)
        fout = open(transmitsteamlinesfile, "w")
        fout.write(json.dumps(jstreamlines))
        fout.close()
    return jstreamlines

def transmitstreamlines(jstreamlines):
    for jout in jstreamlines:
        print("transmitting on", topicstreamdata, "recid", jout["recid"], "lineno", jout["lineno"], "npts", len(jout["points"]))
        client.publish(topicstreamdata, json.dumps(jout))
        
def mergestreamlines(jstreamlines):
    jstreamlinesfore = { }
    jstreamlinesback = { }
    for jout in jstreamlines:
        dt = jout["IntegrationTime"][-1] - jout["IntegrationTime"][0]
        pt0 = tuple(jout["points"][0])
        if dt >= 0:
            jstreamlinesfore[pt0] = jout
        else:
            jstreamlinesback[pt0] = jout
    #print(jstreamlinesback.keys(), jstreamlinesfore.keys())
    jstreamlines = [ ]
    ks = ["points", "IntegrationTime", "p", "U"]
    for pt0, joutb in jstreamlinesback.items():
        joutf = jstreamlinesfore.pop(pt0, None)
        for k in ks:
            joutb[k].reverse()
            if joutf:
                assert joutb[k][-1] == joutf[k][0]
                joutb[k].pop()
                joutb[k].extend(joutf[k])
        if joutf:
            joutb["lineno"] = joutf["lineno"]
        jstreamlines.append(joutb)
    jstreamlines.extend(jstreamlinesfore.values())
    return jstreamlines


# mosquitto_pub -h '{"Point1":[-3.0,0.0,-1.6], "Point2":[3.0,1.0,-1.4]}'

def recstreamdef(v):
    print("recstreamdef ", v)
    recid = v.get("recid", 0)
    pt1 = v["Point1"] if "Point1" in v else q.SeedType.Point1
    pt2 = v["Point2"] if "Point2" in v else q.SeedType.Point2
    jpout = { "recid":recid, "Point1":pt1[:], "Point2":pt2[:] }
    bnegy = ((pt1[1] + pt2[1])/2 < 0)
    if bnegy:
        pt1[1] = -pt1[1]
        pt2[1] = -pt2[1]
    q.SeedType.Point1 = pt1
    q.SeedType.Point2 = pt2

    q.SeedType.Resolution = 5
    q.IntegrationDirection = v.get("IntegrationDirection", "FORWARD")
    
    print("transmitting on", topicstreampredata, "recid", recid, q.IntegrationDirection)
    client.publish(topicstreampredata, json.dumps(jpout))

    print("updating pipeline...")
    q.UpdatePipeline()  # long wait
    print(" done updating pipeline")
    a = e.Fetch(q)
    jstreamlines = extractstreamlines(recid, a, bnegy)
    if q.IntegrationDirection == "BOTH":
        jstreamlines = mergestreamlines(jstreamlines)
    transmitstreamlines(jstreamlines)

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
/nix/store/5s130y6qy7nkp7y640mlmcqffwzl5ww6-python3.12-paho-mqtt-1.6.1/lib/python3.12/site-packages/

sys.path.append("/nix/store/5s130y6qy7nkp7y640mlmcqffwzl5ww6-python3.12-paho-mqtt-1.6.1/lib/python3.12/site-packages/")
"""

