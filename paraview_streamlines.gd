extends Node3D

var brokerurl = "mosquitto.doesliverpool.xyz"

@onready var streamlines = [ $Streamline ]
func _ready():
	$MQTT.connect_to_broker(brokerurl)
	var streamlinescene = load("res://streamlinecode/streamline.tscn")
	for i in range(10):
		var d = streamlinescene.instantiate()
		add_child(d)
		streamlines.append(d)
		d.visible = false

func _process(delta):
	pass

func _on_mqtt_broker_connected():
	$MQTT.subscribe("paraview/#")
	
var Istreamline = 1
func _on_mqtt_received_message(topic, message):
	if topic == "paraview/streamdata":
		var x = JSON.parse_string(message)
		streamlines[Istreamline].setstreampoints(x["points"], x["scalars"])
		Istreamline = (Istreamline + 1) % len(streamlines)
	else:
		print("Rec ", topic, " ", message)

var k = 0.0
func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_T:
		var r = {"Point1":[-3.0,k,-1.6], "Point2":[-3.0,k,-1.4]}
		$MQTT.publish("paraview/streamdef", JSON.stringify(r))
		k += 0.2
		
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_Y:
		$Streamline.setstreampoints(Dpoints, Dscalars)
		return
		var points = [ ]
		for i in range(100):
			points.push_back([(i-50)*0.05, sin(i*0.2)*0.3, cos(i*0.2)*0.3])
		
func _on_pickable_object_action_pressed(pickable):
	print(pickable.transform.origin)
	print(pickable.transform.basis.y)
	var pickablesize = pickable.get_node("MeshInstance3D").mesh.size*pickable.scale
	var pickrad = pickablesize.y*0.5
	var p1 = pickable.transform.origin - pickable.transform.basis.y*pickrad
	var p2 = pickable.transform.origin + pickable.transform.basis.y*pickrad
	var r = {"Point1":[p1.x,-p1.z,p1.y], "Point2":[p2.x,-p2.z,p2.y]}
	$MQTT.publish("paraview/streamdef", JSON.stringify(r))
	print(pickable)
















var Dpoints = [[-3, 0, -1.60000002384186], [-2.8546576499939, 0.00000232910452, -1.59982073307037], [-2.70931529998779, 0.0000050905187, -1.59962141513824], [-2.5641622543335, 0.0000083334071, -1.59940445423126], [-2.41969656944275, 0.00001210657592, -1.5991735458374], [-2.275230884552, 0.00001649596561, -1.59893131256104], [-2.13152718544006, 0.00002156440678, -1.59868311882019], [-1.98845076560974, 0.00002742938159, -1.59843468666077], [-1.84583449363708, 0.00003423803719, -1.59819304943085], [-1.70321822166443, 0.00004216604793, -1.59796512126923], [-1.56095564365387, 0.00005143428643, -1.59776282310486], [-1.4190366268158, 0.00006220845535, -1.59759986400604], [-1.27711749076843, 0.00007444896619, -1.59749102592468], [-1.13563787937164, 0.00008792941662, -1.59745621681213], [-0.99491602182388, 0.00010253693472, -1.59752035140991], [-0.85543709993362, 0.00011854121112, -1.59771382808685], [-0.71595853567123, 0.00013636010408, -1.59807193279266], [-0.57819926738739, 0.00015614066797, -1.59863877296448], [-0.44376996159554, 0.0001789603848, -1.5994690656662], [-0.30532425642014, 0.00020578448311, -1.60071885585785], [-0.16688647866249, 0.00023827492259, -1.60264325141907], [-0.09745143353939, 0.00026005948894, -1.60405445098877], [-0.02892115712166, 0.00028706440935, -1.60592114925385], [0.02712738513947, 0.00031095201848, -1.60807383060455], [0.06158236041665, 0.00032896510675, -1.60982620716095], [0.09543000161648, 0.00034928799141, -1.61199975013733], [0.1286281645298, 0.00037106289528, -1.61471581459045], [0.16175302863121, 0.00039591148379, -1.61820793151855], [0.18137776851654, 0.00041323658661, -1.62076902389526], [0.19939437508583, 0.00043026218191, -1.62345123291016], [0.21767066419125, 0.00044822724885, -1.62646520137787], [0.23590531945229, 0.00046644921531, -1.62972187995911], [0.25057601928711, 0.00048023767886, -1.63247811794281], [0.25913521647453, 0.00048809236614, -1.63410604000092], [0.27586671710014, 0.00050255621318, -1.63729536533356], [0.2925765812397, 0.00051773543237, -1.64039623737335], [0.30931183695793, 0.00053418654716, -1.64335668087006], [0.32607904076576, 0.00055200443603, -1.64615046977997], [0.34288665652275, 0.00057095236843, -1.64881730079651], [0.35970792174339, 0.00059085397515, -1.65139698982239], [0.37656319141388, 0.00061193469446, -1.65394747257233], [0.39348948001862, 0.00063558173133, -1.65653657913208], [0.41040429472923, 0.0006630163989, -1.65919899940491], [0.42660591006279, 0.00069502438419, -1.6618824005127], [0.4427302479744, 0.00073143438203, -1.66470754146576], [0.45882984995842, 0.00077039416647, -1.66767048835754], [0.47483253479004, 0.00080810370855, -1.67072212696075], [0.49228379130363, 0.0008457225631, -1.67407917976379], [0.50974261760712, 0.00087935640477, -1.6773966550827], [0.5283949971199, 0.00090965692652, -1.68082618713379], [0.54683750867844, 0.00093383365311, -1.68404650688171], [0.5653173327446, 0.0009531066753, -1.68704473972321], [0.58458667993546, 0.00096873176517, -1.6898900270462], [0.60114014148712, 0.00097987393383, -1.69209718704224], [0.617984354496, 0.00098856783006, -1.69415950775146], [0.62666994333267, 0.00099226331804, -1.69516468048096], [0.63532948493958, 0.00099641957786, -1.69615530967712], [0.64398676156998, 0.00100087781902, -1.69716501235962], [0.65252828598022, 0.00100491743069, -1.69821918010712], [0.66125470399857, 0.00100859627128, -1.69940161705017], [0.66594457626343, 0.00101065693889, -1.70010149478912], [0.67002606391907, 0.00101258128416, -1.70075476169586], [0.67410099506378, 0.00101454241667, -1.70144736766815], [0.67809218168259, 0.00101641169749, -1.70216202735901], [0.68222147226334, 0.00101822661236, -1.7029322385788], [0.6863477230072, 0.00101979880128, -1.70371854305267], [0.69061249494553, 0.00102102535311, -1.70453000068665], [0.69495719671249, 0.00102169206366, -1.70532977581024], [0.69934678077698, 0.00102180487011, -1.70608699321747], [0.7037467956543, 0.00102150451858, -1.70678079128265], [0.70808267593384, 0.00102107482962, -1.70739376544952], [0.71240192651749, 0.0010207418818, -1.70793688297272], [0.71672850847244, 0.00102063978557, -1.70841789245605], [0.72096502780914, 0.00102085771505, -1.70883417129517], [0.72518008947372, 0.00102137611248, -1.70920193195343], [0.72939121723175, 0.00102218159009, -1.70953154563904], [0.73360460996628, 0.00102323677856, -1.70983147621155], [0.7378648519516, 0.00102443317883, -1.71011352539062], [0.74221700429916, 0.00102573970798, -1.71038913726807], [0.7465695142746, 0.00102701585274, -1.71065974235535], [0.75096923112869, 0.00102808524389, -1.71093535423279], [0.75557225942612, 0.00102901842911, -1.7112340927124], [0.76010894775391, 0.00102972402237, -1.71154427528381], [0.76464426517487, 0.00103015324567, -1.71187353134155], [0.76927119493484, 0.00103033334017, -1.7122323513031], [0.77373480796814, 0.00103019922972, -1.71259760856628], [0.77819681167603, 0.00102982122917, -1.71298205852509], [0.78289347887039, 0.00102926627733, -1.71340847015381], [0.79211962223053, 0.00102758337744, -1.71428716182709], [0.8009460568428, 0.00102602271363, -1.71517097949982], [0.80962818861008, 0.00102470535785, -1.71607303619385], [0.81830751895905, 0.00102377333678, -1.717001080513], [0.8270770907402, 0.00102328998037, -1.71795976161957], [0.83590418100357, 0.00102204503492, -1.71892642974854], [0.85042262077332, 0.00101836386602, -1.72050881385803], [0.86493718624115, 0.00101551006082, -1.72212600708008], [0.87320411205292, 0.00101419177372, -1.72305679321289], [0.88193625211716, 0.00101258128416, -1.72404336929321], [0.89037877321243, 0.00101089337841, -1.72499883174896], [0.89919978380203, 0.00100894866046, -1.72599816322327], [0.90802085399628, 0.00100696529262, -1.72699666023254], [0.91662788391113, 0.00100522872526, -1.72796809673309], [0.92541593313217, 0.00100332242437, -1.72895443439484], [0.93405789136887, 0.00100155803375, -1.72991764545441], [0.94270068407059, 0.00099999608938, -1.73087322711945], [0.95166671276093, 0.00099819269963, -1.73185515403748], [0.96165603399277, 0.00099608220626, -1.73292744159698], [0.97164821624756, 0.00099408777896, -1.7339723110199], [0.98014813661575, 0.00099229963962, -1.73483490943909], [0.9884597659111, 0.00099035107996, -1.73565018177032], [0.99690115451813, 0.00098804722074, -1.73644280433655], [1.00534629821777, 0.00098532706033, -1.73719346523285], [1.01368463039398, 0.00098216393963, -1.73788297176361], [1.02224600315094, 0.00097844772972, -1.73852682113647], [1.03081250190735, 0.00097428559093, -1.73909854888916], [1.03930830955505, 0.00096982100513, -1.73958456516266], [1.04785001277924, 0.00096510909498, -1.73998463153839], [1.05639541149139, 0.00096020882484, -1.74029195308685], [1.0649151802063, 0.00095514516579, -1.74050402641296], [1.0734566450119, 0.00094991415972, -1.74062764644623], [1.08199894428253, 0.00094456470106, -1.74067068099976], [1.09053683280945, 0.00093918055063, -1.74064803123474], [1.0991188287735, 0.00093385804212, -1.74057912826538], [1.10770058631897, 0.00092876161216, -1.74048149585724], [1.11634159088135, 0.00092402083101, -1.74037396907806], [1.12505304813385, 0.0009197643958, -1.74027967453003], [1.13376307487488, 0.00091603153851, -1.7402195930481], [1.14247334003448, 0.0009127711528, -1.74021112918854], [1.15126299858093, 0.00090989813907, -1.74027132987976], [1.15998184680939, 0.00090766599169, -1.74040985107422], [1.1686989068985, 0.0009060590528, -1.7406313419342], [1.1774115562439, 0.000904851011, -1.7409360408783], [1.18600296974182, 0.00090400088811, -1.74131596088409], [1.19459068775177, 0.00090352090774, -1.74177122116089], [1.2032790184021, 0.00090345425997, -1.74230456352234], [1.21217095851898, 0.00090381677728, -1.74292266368866], [1.22198164463043, 0.00090453482699, -1.7436808347702], [1.23178660869598, 0.00090545782587, -1.74450945854187], [1.24158012866974, 0.00090657552937, -1.74539697170258], [1.25063490867615, 0.00090768851805, -1.74626290798187], [1.25956439971924, 0.0009086720529, -1.74715626239777], [1.26849031448364, 0.0009095336427, -1.7480856180191], [1.27709817886353, 0.00091045210138, -1.7490119934082], [1.28561294078827, 0.00091135210823, -1.7499520778656], [1.2941255569458, 0.00091211567633, -1.75091123580933], [1.30281150341034, 0.00091262545902, -1.75190484523773], [1.31220650672913, 0.00091271148995, -1.7529935836792], [1.32160019874573, 0.00091204419732, -1.75409507751465], [1.33084547519684, 0.00091108964989, -1.75518977642059], [1.33985352516174, 0.00091023364803, -1.75626134872437], [1.34860289096832, 0.00090947566787, -1.75730645656586], [1.35735177993774, 0.00090866809478, -1.75835490226746], [1.3662177324295, 0.00090780301252, -1.7594233751297], [1.37000298500061, 0.00090745766647, -1.75987863540649], [1.37378835678101, 0.00090701779118, -1.7603325843811], [1.37834465503693, 0.00090639293194, -1.76087749004364], [1.38280308246613, 0.00090576289222, -1.76140928268433], [1.38737392425537, 0.0009051906527, -1.76195335388184], [1.3919450044632, 0.00090471137082, -1.76249635219574], [1.39646458625793, 0.00090428307885, -1.76303231716156], [1.40102779865265, 0.0009039977449, -1.76357221603394], [1.40555703639984, 0.00090370420367, -1.76410686969757], [1.41024446487427, 0.00090355548309, -1.76465928554535], [1.41493189334869, 0.0009038624703, -1.76521050930023], [1.42023098468781, 0.00090470258147, -1.76583075523376], [1.42481958866119, 0.00090564158745, -1.76636445522308], [1.42940843105316, 0.00090666965116, -1.76689481735229], [1.43379211425781, 0.00090783747146, -1.76739859580994], [1.43832445144653, 0.00090928957798, -1.7679169178009], [1.44287776947021, 0.00091101514408, -1.76843523979187], [1.44743120670319, 0.00091300887289, -1.76895189285278], [1.45204842090607, 0.00091529928613, -1.76947450637817], [1.45666325092316, 0.00091785099357, -1.76999640464783], [1.46133875846863, 0.00092073174892, -1.77052509784698], [1.46601438522339, 0.00092391093494, -1.77105414867401], [1.47080826759338, 0.00092745549046, -1.77159738540649], [1.47626614570618, 0.00093196757371, -1.77221870422363], [1.48179876804352, 0.00093685480533, -1.7728499174118], [1.48733139038086, 0.00094195234124, -1.77348065376282], [1.49197101593018, 0.00094657432055, -1.77401113510132], [1.49645888805389, 0.000951379654, -1.77452611923218], [1.50096797943115, 0.00095652416348, -1.77504515647888], [1.50551116466522, 0.00096199294785, -1.77556955814362], [1.51005423069, 0.00096771272365, -1.77609515190125], [1.51460719108582, 0.00097366678528, -1.7766227722168], [1.51918566226959, 0.0009798493702, -1.77715384960175], [1.5238231420517, 0.00098630168941, -1.77769184112549], [1.52846074104309, 0.00099295121618, -1.77822911739349], [1.53323340415955, 0.00100001366809, -1.7787801027298], [1.53816282749176, 0.00100758613553, -1.7793470621109], [1.54306280612946, 0.00101540784817, -1.77990746498108], [1.54853236675262, 0.00102441955823, -1.78052961826324], [1.55326819419861, 0.00103236944415, -1.78106355667114], [1.55791425704956, 0.00104027392808, -1.7815819978714], [1.56260859966278, 0.00104840181302, -1.78210055828094], [1.56730341911316, 0.00105667649768, -1.78261411190033], [1.57205092906952, 0.00106518308166, -1.78312921524048], [1.5767627954483, 0.00107380189002, -1.78363752365112], [1.58143746852875, 0.00108260230627, -1.78413951396942], [1.58611238002777, 0.00109170179348, -1.78463983535767], [1.59072637557983, 0.00110103189945, -1.7851322889328], [1.59535157680511, 0.00111071357969, -1.78562653064728], [1.60007095336914, 0.00112087931484, -1.78613245487213], [1.60479009151459, 0.00113126891665, -1.78663980960846], [1.60965418815613, 0.00114214932546, -1.78716468811035], [1.61461341381073, 0.00115342542995, -1.78770196437836], [1.61947584152222, 0.00116479373537, -1.78823053836823], [1.62416100502014, 0.0011761020869, -1.78874123096466], [1.62884604930878, 0.0011878068326, -1.78925287723541], [1.63347220420837, 0.00119977921713, -1.78975892066956], [1.63825440406799, 0.00121252273675, -1.79028284549713], [1.64322769641876, 0.00122625264339, -1.79082858562469], [1.64820086956024, 0.00124040385708, -1.79137563705444], [1.6528594493866, 0.00125384586863, -1.79188942909241], [1.65746629238129, 0.00126739009283, -1.79239678382874], [1.66200423240662, 0.00128099322319, -1.7928946018219], [1.6665426492691, 0.00129482115153, -1.79338872432709], [1.67106223106384, 0.00130879576318, -1.79387521743774], [1.67579734325409, 0.00132413639221, -1.79437458515167], [1.68079912662506, 0.00134076515678, -1.79488635063171], [1.68580269813538, 0.00135746807791, -1.79538094997406], [1.69076859951019, 0.00137390277814, -1.79585707187653], [1.69572997093201, 0.00139022571966, -1.79632246494293], [1.70057332515717, 0.00140630220994, -1.79677045345306], [1.70525217056274, 0.00142208044417, -1.79719913005829], [1.7099312543869, 0.0014381678775, -1.79762542247772], [1.71447646617889, 0.00145410210826, -1.79803788661957], [1.71910989284515, 0.00147025997285, -1.79845833778381], [1.72390842437744, 0.0014865527628, -1.7988942861557], [1.72870695590973, 0.0015022654552, -1.79933083057404], [1.73372161388397, 0.00151805416681, -1.79978692531586], [1.73863315582275, 0.00153350655455, -1.80023336410522], [1.74347317218781, 0.00154870061669, -1.8006728887558], [1.74831318855286, 0.00156380946282, -1.80111241340637], [1.7530210018158, 0.00157861795742, -1.80153977870941], [1.7575935125351, 0.00159301969688, -1.80195498466492], [1.76207852363586, 0.00160714518279, -1.80236232280731], [1.76656353473663, 0.00162130733952, -1.80276906490326], [1.77105581760406, 0.00163550209254, -1.80317568778992], [1.77580749988556, 0.00165014946833, -1.8036048412323], [1.78082871437073, 0.00166476005688, -1.8040554523468], [1.78585040569305, 0.00167865329422, -1.80450141429901], [1.79078280925751, 0.00169233197812, -1.80493330955505], [1.79569220542908, 0.00170578539837, -1.80535495281219], [1.80052065849304, 0.00171959318686, -1.80575692653656], [1.80535089969635, 0.00173468550202, -1.80613791942596], [1.81012189388275, 0.00175070599653, -1.80648422241211], [1.81473255157471, 0.00176580110565, -1.80678510665894], [1.81922721862793, 0.00177898816764, -1.80705237388611], [1.82363867759705, 0.00179108825978, -1.807297706604], [1.8280508518219, 0.00180299545173, -1.80753123760223], [1.83246445655823, 0.00181501242332, -1.80775594711304], [1.8369505405426, 0.00182750693057, -1.80797636508942], [1.84143698215485, 0.00184045766946, -1.80818963050842], [1.84620821475983, 0.00185543147381, -1.80840969085693], [1.85266745090485, 0.00187791185454, -1.80869686603546], [1.85826516151428, 0.00189401954412, -1.80894041061401], [1.86328458786011, 0.00190667808056, -1.80915462970734], [1.86811804771423, 0.00191844825167, -1.8093569278717], [1.8728621006012, 0.00192944623996, -1.80955183506012], [1.87752866744995, 0.00193997868337, -1.80974054336548], [1.88215267658234, 0.00195056712255, -1.80992472171783], [1.88674807548523, 0.00196142587811, -1.81010448932648], [1.89134347438812, 0.00197256193496, -1.81028091907501], [1.89599299430847, 0.00198409077711, -1.81045591831207], [1.90061008930206, 0.00199591880664, -1.81062626838684], [1.90520071983337, 0.0020083039999, -1.81079137325287], [1.90979170799255, 0.00202154554427, -1.81095087528229], [1.91434109210968, 0.00203565158881, -1.81110179424286], [1.91884672641754, 0.00205067847855, -1.81124067306519], [1.9232931137085, 0.0020668071229, -1.81136393547058], [1.92773985862732, 0.00208507594652, -1.81146550178528], [1.9321141242981, 0.0021076600533, -1.8115222454071], [1.93639934062958, 0.0021325214766, -1.81152486801147], [1.94068431854248, 0.00215816311538, -1.8114767074585], [1.94501328468323, 0.00218173325993, -1.81139528751373], [1.94937121868134, 0.00220448011532, -1.81129229068756], [1.95372867584229, 0.0022271363996, -1.81117475032806], [1.95811355113983, 0.00225037778728, -1.8110454082489], [1.96251666545868, 0.00227400218137, -1.810906291008], [1.96693968772888, 0.00229808408767, -1.81075859069824], [1.97136247158051, 0.00232264911756, -1.81060409545898], [1.97580063343048, 0.00234794430435, -1.81044316291809], [1.98025512695312, 0.00237407325767, -1.81027638912201], [1.9847092628479, 0.00240096170455, -1.81010496616364], [1.98917698860168, 0.00242865039036, -1.8099285364151], [1.99352240562439, 0.00245630159043, -1.8097528219223], [1.99786758422852, 0.00248484360054, -1.80957293510437], [2.00222086906433, 0.00251450855285, -1.80938851833344], [2.00658106803894, 0.00254496908747, -1.80919981002808], [2.01094579696655, 0.00257591390982, -1.809006690979], [2.01531052589417, 0.00260721729137, -1.8088093996048], [2.0196738243103, 0.00263920170255, -1.80860650539398], [2.02403593063354, 0.00267204619013, -1.80839669704437], [2.02839732170105, 0.00270589091815, -1.80817759037018], [2.03274869918823, 0.00274073332548, -1.80794584751129], [2.03711485862732, 0.00277650658973, -1.80769562721252], [2.04154586791992, 0.00281689572148, -1.80739593505859], [2.04597067832947, 0.00286386464722, -1.80701959133148], [2.05057406425476, 0.00291834049858, -1.80651903152466], [2.05536890029907, 0.00297632976435, -1.80590903759003], [2.06068539619446, 0.00303613045253, -1.80516123771667], [2.06661081314087, 0.00308607914485, -1.80428409576416], [2.07253313064575, 0.00311282929033, -1.80338478088379], [2.07687926292419, 0.00313332234509, -1.80270874500275], [2.08124303817749, 0.00315310386941, -1.80201995372772], [2.08584761619568, 0.00317118689418, -1.80128645896912], [2.09045171737671, 0.00318670994602, -1.80054986476898], [2.09527683258057, 0.00320303905755, -1.79977548122406], [2.10065460205078, 0.00322242244147, -1.79890489578247], [2.10651397705078, 0.00323474197648, -1.79794979095459], [2.1107394695282, 0.00324056856334, -1.79726088047028], [2.11496520042419, 0.00324805337004, -1.7965726852417], [2.11941885948181, 0.00325715588406, -1.79584801197052], [2.12394762039185, 0.00326563883573, -1.79511630535126], [2.12905311584473, 0.00327464798465, -1.7942932844162], [2.13415837287903, 0.00328247365542, -1.79346752166748], [2.1397864818573, 0.00328539451584, -1.79255020618439], [2.14408731460571, 0.00328543689102, -1.79183673858643], [2.14880561828613, 0.00327677233145, -1.79104316234589], [2.15422415733337, 0.00326529424638, -1.79013407230377], [2.15976476669312, 0.00327074620873, -1.78921246528625], [2.1655867099762, 0.00328704668209, -1.78824555873871], [2.1704158782959, 0.00328596681356, -1.78748345375061], [2.17531609535217, 0.00327840377577, -1.78675830364227], [2.18016767501831, 0.00326634314843, -1.78608477115631], [2.18501734733581, 0.00325477612205, -1.7854562997818], [2.18987321853638, 0.00324917957187, -1.78487586975098], [2.19475722312927, 0.00325666042045, -1.78434920310974], [2.19962859153748, 0.003289377084, -1.78389620780945], [2.20446729660034, 0.00335947680287, -1.78353786468506], [2.20931196212769, 0.00348016922362, -1.78328943252563], [2.21408462524414, 0.00366405211389, -1.78317296504974], [2.21883606910706, 0.00393951917067, -1.78320133686066], [2.22412872314453, 0.00439267978072, -1.78341090679169], [2.22974443435669, 0.00499355979264, -1.78384745121002], [2.23530292510986, 0.00567621178925, -1.78442823886871], [2.24017214775085, 0.00636510411277, -1.78503167629242], [2.24657225608826, 0.00729740224779, -1.78593993186951], [2.25282096862793, 0.00815694406629, -1.7868994474411], [2.25865650177002, 0.00889530126005, -1.78786671161652], [2.26854348182678, 0.01007456891239, -1.78960013389587], [2.27794551849365, 0.01113354880363, -1.79119741916656], [2.28737926483154, 0.0120012126863, -1.79271912574768], [2.30865931510925, 0.01346413698047, -1.79588878154755], [2.32817673683167, 0.01481473818421, -1.79862797260284], [2.34691667556763, 0.01614830456674, -1.80100560188293], [2.37316250801086, 0.01757520996034, -1.80386555194855], [2.41558694839478, 0.01893113553524, -1.80792725086212], [2.44866585731506, 0.01963340304792, -1.81138908863068], [2.48258590698242, 0.02027233876288, -1.81501805782318], [2.51644277572632, 0.02084053494036, -1.8186616897583], [2.55031394958496, 0.02128174714744, -1.82218670845032], [2.58373832702637, 0.02156391181052, -1.82557129859924], [2.65184807777405, 0.02192684821784, -1.83243107795715], [2.71859312057495, 0.02224637009203, -1.83911335468292], [2.78760552406311, 0.02257284708321, -1.84594476222992], [2.85653805732727, 0.0228926781565, -1.85260426998138], [2.9254937171936, 0.02316636405885, -1.85902535915375], [3.06712198257446, 0.02352438308299, -1.87161874771118], [3.2051956653595, 0.02383094094694, -1.88348531723022], [3.34328055381775, 0.02414049766958, -1.89522480964661], [3.48343324661255, 0.02446429431438, -1.90696859359741], [3.62401008605957, 0.02481148764491, -1.91852128505707], [3.76522302627564, 0.02518074400723, -1.92993807792664], [3.9064474105835, 0.02556629292667, -1.94121086597443], [4.04802942276001, 0.0259656496346, -1.95238590240479], [4.18987989425659, 0.02637410722673, -1.96348309516907], [4.33173608779907, 0.0267885774374, -1.97450339794159], [4.47377252578735, 0.02720848470926, -1.98547637462616], [4.61591958999634, 0.02763337828219, -1.99640941619873], [4.75813102722168, 0.02806047350168, -2.00730061531067], [4.90075063705444, 0.02847723476589, -2.01812100410461], [5.04340028762817, 0.0288823004812, -2.02882695198059], [5.18606901168823, 0.02927790768445, -2.03941631317139], [5.32874631881714, 0.02966612949967, -2.04988980293274], [5.47143602371216, 0.03004891984165, -2.0602490901947], [5.6141357421875, 0.03042800724506, -2.07049703598022], [5.75684452056885, 0.0308048389852, -2.08063697814941], [5.89955997467041, 0.03118067234755, -2.09067392349243], [6.04228401184082, 0.03155778720975, -2.10060739517212], [6.18501472473145, 0.03193816915154, -2.11043834686279], [6.32775211334229, 0.03232283517718, -2.12017202377319], [6.47049617767334, 0.03271267935634, -2.12981295585632], [6.61324644088745, 0.03310843929648, -2.13936591148376], [6.7560019493103, 0.03351069241762, -2.14883613586426], [6.89876222610474, 0.03391984477639, -2.15822958946228], [7.04152727127075, 0.03433613479137, -2.16755056381226], [7.18429613113403, 0.03475958481431, -2.17680478096008], [7.32706880569458, 0.03519008681178, -2.18599724769592], [7.46984529495239, 0.03562740236521, -2.19513297080994], [7.61262607574463, 0.03607119619846, -2.20421695709229], [7.75541067123413, 0.03651498258114, -2.21323418617249], [7.8987889289856, 0.03695481270552, -2.22220396995544], [8.0421724319458, 0.03738983348012, -2.2310893535614], [8.18556213378906, 0.03782108798623, -2.23989129066467], [8.32895565032959, 0.03824954107404, -2.24861145019531], [8.47235584259033, 0.0386760905385, -2.25725126266479], [8.61575889587402, 0.03910154104233, -2.26581239700317], [8.75916767120361, 0.03952665254474, -2.27429628372192], [8.90258026123047, 0.03995215147734, -2.28270530700684], [9.04599666595459, 0.04037873074412, -2.29104089736938], [9.18941688537598, 0.0408070422709, -2.29930520057678], [9.33284187316894, 0.04123763367534, -2.30750060081482], [9.47627067565918, 0.04167097806931, -2.31562900543213], [9.619704246521, 0.04210746660829, -2.32369256019592], [9.76314067840576, 0.04254744574428, -2.33169341087341], [9.90657997131348, 0.04299123585224, -2.33963394165039], [10.0500221252441, 0.04343908280134, -2.34751582145691], [10.1934680938721, 0.04389119148254, -2.3553409576416], [10.3369169235229, 0.04434771835804, -2.3631112575531], [10.4803686141968, 0.04480878636241, -2.37082862854004], [10.6238241195679, 0.04527451097965, -2.37849402427673], [10.7672805786133, 0.04574501141906, -2.38610935211182], [10.9107389450073, 0.04622036591172, -2.39367580413818], [11.0542011260986, 0.04670061171055, -2.40119504928589], [11.1976661682129, 0.04718572646379, -2.40866804122925], [11.341869354248, 0.04767334461212, -2.41612982749939], [11.4860754013062, 0.04815747588873, -2.42353940010071], [11.6302852630615, 0.04863836616278, -2.43089652061462], [11.7744970321655, 0.04911628365517, -2.43820118904114], [11.9187116622925, 0.04959151893854, -2.44545388221741], [12.0629272460938, 0.05006437003613, -2.45265436172485], [12.2071475982666, 0.05053516104817, -2.45980310440063], [12.3513698577881, 0.05100420862436, -2.46690011024475], [12.4955959320068, 0.05147179961205, -2.47394609451294], [12.6398229598999, 0.05193816870451, -2.48094081878662], [12.7840538024902, 0.0524035282433, -2.48788499832153], [12.9282875061035, 0.05286804959178, -2.49477887153625], [13.0725269317627, 0.05333189293742, -2.50162315368652], [13.2167797088623, 0.05379519611597, -2.50841879844666], [13.36106300354, 0.05425810068846, -2.51516699790955], [13.5053482055664, 0.05472060292959, -2.52186703681946], [13.6497011184692, 0.05518298223615, -2.52852320671081], [13.7941942214966, 0.05564554035664, -2.53513884544373], [13.9386901855469, 0.05610787123442, -2.54170918464661], [14.0834522247314, 0.05657084286213, -2.54824686050415], [14.2286653518677, 0.05703501775861, -2.55476117134094], [14.3745384216309, 0.05750102549791, -2.56126189231873], [14.520414352417, 0.05796670541167, -2.56772112846375], [14.6670846939087, 0.05843448266387, -2.57417488098145], [14.8144378662109, 0.0589038208127, -2.58061909675598], [14.9617929458618, 0.0593722499907, -2.5870246887207], [15.1092958450317, 0.05983986333013, -2.59339928627014], [15.2558298110962, 0.06030276045203, -2.5996949672699], [15.3992586135864, 0.06075340509415, -2.60582113265991], [15.5426893234253, 0.06120240688324, -2.61190843582153], [15.6802396774292, 0.06163169816136, -2.61770391464233], [15.8119115829468, 0.06202653050423, -2.6232225894928], [15.9398307800293, 0.06240801885724, -2.62853074073792]]
var Dscalars = [1.30144882202148, 1.35197150707245, 1.41291427612305, 1.48204982280731, 1.56080341339111, 1.6555187702179, 1.761270403862, 1.87870812416077, 2.0168821811676, 2.17435479164124, 2.34970617294312, 2.54789638519287, 2.78336548805237, 3.05103731155396, 3.35433387756348, 3.71562314033508, 4.16467189788818, 4.70863246917725, 5.38002014160156, 6.33204555511475, 8.19162750244141, 9.38030910491943, 10.3907623291016, 12.8849487304688, 14.129322052002, 15.2946395874023, 16.5378513336182, 17.3025722503662, 17.2178039550781, 16.7319812774658, 15.1094093322754, 13.2718324661255, 11.7577180862427, 10.4785604476929, 8.12196254730225, 6.1721773147583, 4.92148542404175, 4.3243579864502, 4.55352544784546, 5.05896186828613, 5.68994331359863, 6.32162189483643, 6.75684785842896, 6.98553371429443, 6.82482719421387, 6.32445907592773, 5.70738315582275, 5.00724124908447, 4.56433582305908, 4.11686992645264, 3.66697096824646, 3.40761160850525, 3.39800691604614, 3.58150410652161, 4.06914091110229, 4.27181625366211, 4.58802843093872, 5.04108476638794, 5.48071241378784, 5.63333702087402, 5.48545980453491, 5.09448719024658, 4.22709798812866, 2.95322942733765, 1.18017637729645, -1.29292738437653, -4.03567552566528, -6.93873643875122, -9.42898559570312, -11.0696067810059, -12.0068330764771, -12.2298402786255, -11.6673784255981, -10.7918090820312, -9.65435028076172, -8.10564041137695, -6.52429246902466, -4.89832401275635, -3.20750141143799, -1.66932010650635, -0.26751631498337, 0.98498332500458, 1.87446129322052, 2.48570775985718, 2.85462331771851, 3.00681304931641, 2.88798761367798, 2.73083591461182, 2.35290884971619, 1.97605490684509, 1.70016205310822, 1.42675375938416, 1.04154396057129, 0.40926828980446, -0.17229464650154, -0.79346174001694, -1.10854530334473, -1.50205564498901, -1.91126489639282, -2.36249899864197, -2.85190725326538, -3.34600877761841, -3.8792188167572, -4.4373140335083, -5.09248924255371, -5.85338497161865, -6.57811784744263, -7.38395690917969, -8.12555408477783, -8.88020992279053, -9.64580345153809, -10.3866367340088, -11.0919885635376, -11.7280893325806, -12.2235546112061, -12.5621919631958, -12.6084260940552, -12.2204275131226, -11.51149559021, -10.362943649292, -8.67982006072998, -6.77552652359009, -4.64905881881714, -2.38321542739868, -0.14130763709545, 2.05713677406311, 3.97253561019897, 5.6338267326355, 7.06231498718262, 8.12015056610107, 8.87572002410889, 9.41347885131836, 9.71948146820068, 9.80078315734863, 9.75100421905518, 9.57320690155029, 9.26225280761719, 8.94807147979736, 8.6115026473999, 8.28790855407715, 7.94950580596924, 7.55982542037964, 7.18336009979248, 6.84858226776123, 6.45519638061523, 6.11656618118286, 5.79459381103516, 5.37595081329346, 5.00074195861816, 4.68348979949951, 4.39454221725464, 4.08369016647339, 3.75741171836853, 3.75301647186279, 3.66696429252625, 3.51312065124512, 3.33596515655518, 3.15759873390198, 2.98573350906372, 2.81732559204102, 2.64055466651917, 2.45536661148071, 2.24613094329834, 2.0464026927948, 1.90462744235992, 1.79528796672821, 1.65795862674713, 1.52187073230743, 1.38958382606506, 1.28476011753082, 1.19531714916229, 1.10969793796539, 1.02469825744629, 0.93561375141144, 0.84247475862503, 0.73015880584717, 0.59588378667831, 0.48469239473343, 0.3832588493824, 0.27541550993919, 0.15647348761559, 0.02561215870082, -0.11059052497149, -0.25574707984924, -0.41189447045326, -0.58085894584656, -0.77426415681839, -0.97647893428802, -1.18930304050446, -1.41120374202728, -1.62257587909698, -1.82726573944092, -1.97015392780304, -2.074458360672, -2.12247157096863, -2.09808421134949, -2.05907726287842, -2.02501797676086, -2.01518893241882, -2.03068709373474, -2.0585834980011, -2.09422993659973, -2.14330053329468, -2.18618845939636, -2.24224066734314, -2.31916856765747, -2.41883492469788, -2.54299736022949, -2.70207667350769, -2.88033485412598, -3.07241654396057, -3.27489733695984, -3.50871825218201, -3.76357293128967, -4.050452709198, -4.37599325180054, -4.73439359664917, -5.10120391845703, -5.47351312637329, -5.73215675354004, -5.71548557281494, -5.51953744888306, -5.25677967071533, -5.06664657592773, -4.94460773468018, -4.83450508117676, -4.74780511856079, -4.68783473968506, -4.67306613922119, -4.67027807235718, -4.68000745773315, -4.704993724823, -4.76164388656616, -4.84381437301636, -4.95062923431396, -5.08638143539429, -5.26409292221069, -5.48985624313354, -5.75348138809204, -6.06098318099976, -6.40073871612549, -6.80922031402588, -7.32179355621338, -7.96158313751221, -8.68548679351807, -9.46392059326172, -9.84256744384766, -9.71243190765381, -9.14484882354736, -8.46210956573486, -7.98501682281494, -7.63512659072876, -7.37872743606567, -7.18520593643188, -6.94800472259521, -6.72694635391235, -6.60301542282104, -6.51786184310913, -6.48297786712646, -6.46590137481689, -6.50101470947266, -6.60765647888184, -6.7788872718811, -6.96984720230103, -7.20570755004883, -7.50465440750122, -7.95203733444214, -8.5156078338623, -9.19377994537354, -9.9960470199585, -11.034158706665, -12.3566055297852, -13.6102390289307, -13.8133754730225, -12.644383430481, -11.0315914154053, -9.58375644683838, -8.754150390625, -8.11441993713379, -7.59103012084961, -7.10619831085205, -6.67678785324097, -6.30291938781738, -6.01113176345825, -5.78145408630371, -5.59933567047119, -5.47102737426758, -5.42166996002197, -5.40240478515625, -5.41686487197876, -5.5257568359375, -5.76290512084961, -6.11238718032837, -6.60460329055786, -7.33954954147339, -8.29171943664551, -9.5330228805542, -11.7562084197998, -12.7674713134766, -11.9402027130127, -9.04331111907959, -5.71031141281128, -3.77103686332703, -1.40656554698944, -0.01340783573687, 1.00997960567474, 2.11950159072876, 3.1298713684082, 4.01862096786499, 4.94299173355103, 6.04827308654785, 6.88385057449341, 7.50990152359009, 8.1703405380249, 9.04355144500732, 9.69278430938721, 10.3852825164795, 11.1846647262573, 11.8165168762207, 12.6506824493408, 14.4101257324219, 16.0517387390137, 17.6784210205078, 18.8975219726562, 19.8438835144043, 20.4504337310791, 21.3107948303223, 22.1501502990723, 23.0298614501953, 24.0385322570801, 25.1146087646484, 26.0947933197021, 26.83717918396, 27.1501770019531, 26.738317489624, 26.0853443145752, 25.164514541626, 23.6959762573242, 21.8304824829102, 19.6983394622803, 18.1483974456787, 16.3527946472168, 14.5711393356323, 13.1754379272461, 10.671275138855, 9.09356784820557, 8.05974197387695, 7.05238485336304, 6.01421213150024, 5.31478404998779, 4.68925857543945, 4.26930904388428, 3.99570965766907, 3.8891384601593, 3.57739067077637, 3.24959421157837, 2.9157407283783, 2.56208872795105, 2.35195755958557, 2.0673463344574, 1.91279590129852, 1.76813423633575, 1.63033640384674, 1.50300800800323, 1.39984107017517, 1.30382359027863, 1.21320080757141, 1.12795829772949, 1.05819308757782, 0.9948947429657, 0.93705928325653, 0.88431763648987, 0.83536612987518, 0.79042953252792, 0.75003641843796, 0.71480733156204, 0.68222784996033, 0.65198528766632, 0.6244250535965, 0.59892719984055, 0.5752375125885, 0.55368989706039, 0.53450584411621, 0.51664310693741, 0.49999311566353, 0.48496067523956, 0.47093915939331, 0.45766890048981, 0.44521620869637, 0.43373709917068, 0.42293033003807, 0.41284355521202, 0.40345096588135, 0.39497795701027, 0.38726305961609, 0.3803229033947, 0.37413594126701, 0.36840814352036, 0.36313724517822, 0.35857081413269, 0.35457363724709, 0.35101324319839, 0.34789687395096, 0.34523418545723, 0.34279608726501, 0.34055113792419, 0.33853697776794, 0.33666971325874, 0.33494806289673, 0.33341714739799, 0.33229631185532, 0.33148261904716, 0.33095195889473, 0.330735206604, 0.33066233992577, 0.33064311742783, 0.33060520887375, 0.33003878593445, 0.32959708571434, 0.32928755879402, 0.32914665341377, 0.32912328839302, 0.3291377723217, 0.32915738224983, 0.32907271385193, 0.32888245582581, 0.32860991358757, 0.32825967669487, 0.32781293988228, 0.32722279429436, 0.32645425200462, 0.32535031437874, 0.3238617181778, 0.32198828458786, 0.31965944170952, 0.31651443243027, 0.31263223290443, 0.30790591239929, 0.30171895027161, 0.29371064901352, 0.28392988443375, 0.27199131250381, 0.25603196024895, 0.23686684668064, 0.21428927779198, 0.18604183197021, 0.15036468207836, 0.11160877346992, 0.07345799356699, 0.03167213499546]
