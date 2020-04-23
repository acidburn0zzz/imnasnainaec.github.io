data = open('OZlife_mammal.js','r')

line = data.readline()
tree = ","+line.split('"')[1]
chop = tree.split("]")
for i in range(len(chop)-1):
	log = chop[i]
	if log[0]==":":
		a = max(log.find(","),log.find(")"))
		chop[i-1].append(log[1:a])
		log = log[a:]
	if log[0]==")":
		chop[i-1][4] = False
	#wood = [leaf?, number of (, name, number, First of a pair?, time]
	wood = [(log[0]!=")")]
	pars = 0
	while log[pars+1]=="(":
		pars += 1
	log = log[pars+1:]
	wood.append(pars)
	wood.extend(log.split("["))
	wood[-1] = int(wood[-1])
	wood.append(True)
	chop[i] = wood
chop[-2].append(chop[-1][1:-1])
chop.pop(-1)
chop[-1][4] = False

def tree_printer(i):
	a = chop[i]
	text = (not a[0])*")" + "("*a[1] + a[2] + "[" + str(a[3]) + "]" 
	if len(a)==6:
		text += ":" + a[5]
	return text + a[4]*","
	
def js_print(filename):
	out = open(filename+".js","w")
	out.write('var rawData = "')
	for i in range(len(chop)):
		out.write(tree_printer(i))
	out.write(';";\n\n' + "var metadata = {" + '\n\n' + "'leaf_meta': [" + '\n["')
	meta = ""
	for ml in l_dic:
		meta += ml + '","'
	out.write(meta[:-2] + "],")	
	
	for L in leafs:
		out.write('\n[')
		for i in range(len(L)):
			if L[i]:
				if (i==0 or i==6 or i==13):
					out.write(str(L[i]))
				else:
					out.write('"' + L[i] + '"')
			if i<len(L)-1:
				out.write(",")
		out.write("],")
	
	out.write('\n],\n\n' + "'node_meta': [" + '\n["')
	meta = ""
	for mn in n_dic:
		meta += mn + '","'
	out.write(meta[:-2] + "],")	
	
	for N in nodes:
		out.write('\n[')
		for i in range(len(N)):
			if N[i]:
				if (i==0):
					out.write(str(N[i]))
				else:
					out.write('"' + N[i] + '"')
			if i<len(N)-1:
				out.write(",")
		out.write("],")
	out.write('\n]};\n')
	out.close()

def spanStr(species):
	for i in range(len(chop)):
		if chop[i][2]==species:
			if chop[i][0]==True:
				return (i,i,0)
			d,j = 1,i
			while d>0:
				j -= 1
				d += (not chop[j][0]) - chop[j][1]
			return (i,j,abs(d))

def spanInt(index):
	for i in range(len(chop)):
		if not chop[i][0] and chop[i][3]==index:
			d,j = 1,i
			while d>0:
				j -= 1
				d += (not chop[j][0]) - chop[j][1]
			#print chop[i]
			return (i,j,abs(d))
	return False

def clean(new):
	next = []
	while len(new)>0:
		if new[0]=='"':
			a = new[1:].index('"')
			next.append(new[1:a+1])
			new = new[a+2:]
		elif new[0]==",":
			next.append(False)
		else:
			a = new.find(",")
			if a==-1:
				a = len(new)
			next.append(int(new[:a]))
			new = new[a:]
		if len(new)>0 and new[0]==",":
			new = new[1:]
	return next

while line[0]!="[":
	line = data.readline()
l_dic = line[2:-4].split('","')
leafs = []
line = data.readline()
while line[0]=="[":
	leafs.append(clean(line[1:-3]))
	line = data.readline()
#print len(leafs), l_dic

while line[0]!="[":
	line = data.readline()
n_dic = line[2:-4].split('","')
nodes = []
line = data.readline()
while line[0]=="[":
	nodes.append(clean(line[1:-3]))
	line = data.readline()
#print len(nodes), n_dic
	
def node_leafs(index):
	L = []
	N = []
	breadth = spanInt(index)
	if not breadth:
		return false
	for i in range(breadth[1],breadth[0]+1):
		if chop[i][0]:
			L.append(chop[i][3])
		else:
			N.append(chop[i][3])
	return (L,N)

def used():
	global Li
	global Ni
	Li = [False]*(len(leafs)+1)
	Ni = [False]*(len(nodes)+1)
	LiNi = node_leafs(chop[-1][3])
	#print len(Li),max(LiNi[0]),len(Ni),max(LiNi[1])
	for li in LiNi[0]:
		Li[li] = True
	for ni in LiNi[1]:
		Ni[ni] = True
	#print len(Li), sum(Li), len(Ni), sum(Ni)

used()

def cut(index, new=[]):
	if not Ni[index]:
		return False
		
	#Collect info about what will be upgraded and what will be chopped
	span = spanInt(index)
	#print span, chop[span[0]], chop[span[1]]
	
	#If one of the dying leafs has an image, we'll convert it to the new leaf
	oldNode = nodes[chop[span[0]][3]-1]
	if len(oldNode)<1:
		oldNode.append(False)
	if len(oldNode)<2:
		if len(chop[span[0]][2])>0:
			oldNode.append(chop[span[0]][2])
	newLeafInd = chop[span[1]][3]
	for i in range(span[1]+1,span[0]):
		if ( chop[i][0] and leafs[chop[i][3]-1][4] ):
			newLeafInd = chop[i][3]
			break
	#print oldNode, newLeafInd, leafs[newLeafInd-1]
	
	#Develop the new leaf
	newLeaf = leafs[newLeafInd-1]
	while len(newLeaf)<len(l_dic):
		newLeaf.append(False)
	for i in range(len(oldNode)): #copy the node information into the new leaf
		if oldNode[i]:
			newLeaf[i] = oldNode[i]
	for i in range(len(new)): #copy the user-added info into the new leaf
		if new[i]:
			newLeaf[i] = new[i]
	newLeaf[7] = False
	species = 0
	for i in range(span[1],span[0]):
		if chop[i][0]:
			if ( len(leafs[chop[i][3]-1])==len(l_dic) and leafs[chop[i][3]-1][-1] ):
				species += leafs[chop[i][3]-1][-1]
			else:
				species += 1
	newLeaf[-1] = species
	#print newLeaf, leafs[newLeafInd-1]
	
	#Convert the old node to the new leaf
	chop[span[0]][0] = True #The node is becoming a leaf
	chop[span[0]][1] = span[2] #We need to keep all the parentheses that won't be cut
	if len(new)>1 and new[1]: #If a new scientific name has been give...
		chop[span[0]][2] = new[1] #... then use it
	chop[span[0]][3] = newLeafInd #Give the new leaf its new index
	if len(chop[span[0]])<6:#Commence consolidation of clade's age
		chop[span[0]].append('0')
	firsts, lasts = 0, 0
	for i in range(span[1],span[0]):
		if chop[i][4]:
			if len(chop[i])==6:
				firsts += float(chop[i][5])
		else:
			if len(chop[i])==6:
				lasts += float(chop[i][5])
	chop[span[0]][5] = str(float(chop[span[0]][5]) + max(firsts,lasts))
	#print chop[span[0]]
	
	#Cut all the old wood
	for i in range(span[1],span[0]):
		junk = chop.pop(span[1])
	#print chop[span[1]-1], chop[span[1]]
	
def cutName(name, new=[]):
	for wood in chop:
		if wood[2]==name:
			cut(wood[3],new)
			break
	return False
	
def nodeLabel(i, new=[]):
	while len(nodes[i-1])<len(new):
		nodes[i-1].append(False)
	for j in range(len(new)):
		if new[j]:
			nodes[i-1][j] = new[j]
	if (len(new)>1 and new[1]):
		for wood in chop:
			if ((not wood[0]) and wood[3]==i):
				wood[2] = new[1]
				
def mergeLeafs(i, j, new=[]):
	return False
	
#####################################################
#Mammals

#Changes to Marsupials and Altantogenata
cutName("Macropus", [False,False,"Kangaroo, Wallaroo, Wallaby"])
cutName("Cingulata", [False,False,"Armadillo : Pichi"])
cutName("Vermilingua", [False,False,"Anteater: Ant Bear, Tamandua"])
cutName("Antechinus", [False,False,"Antechinus / Marsupial Mouse : Mardo"])
cutName("Phalangeriformes", [False,False,"Possum, Glider, Cuscus, Triok"])
nodeLabel(9915, [False,False,"Bandicoot, Dasyure, etc."])

#Changes to Even-toed Ungulates
cutName("Tayassuidae", [False,"Pecari","Peccary / Javelina / Skunk Pig"])
cutName("Babyrousa", [False,False,"Babirusa / Pig-deer"])
cutName("Phacochoerus", [False,False,"Warthog"])
cutName("Sus", [False,False,"Pig, Warty Pig, Bearded Pig : Hog, Boar, Swine"])
cutName("Eubalaena", [False,False,"Right Whale"])
cutName("Physeteridae", [False,False,"Sperm Whale"])
#cutName("Platanistidae", [False,False,"River Dolphin : Susu, Shushuk, Bhulan"])
cutName("Ziphiidae", [False,False,"Beaked Whale, Bottlenose Whale : Spade-toothed Whale, Strap-toothed Whale"])
cutName("Phocoenidae", [False,False,"Porpoise / Mereswine : Vaquita"])
cutName("Globicephala", [False,False,"Pilot Whale"])
cutName("Lissodelphis", [False,False,"Right Whale Dolphin"])
cut(9178, [False,False,"Minke Whale / Lesser Rorqual"])
nodeLabel(9184, [False,"Balaenopteridea","Rorqual"])
cutName("Sousa", [False,False,"Humpback Dolphin"])
cutName("Tursiops", [False,False,"Bottlenose Dolphin"])
cutName("Delphinus", [False,False,"Common Dolphin"])
cutName("Tragulidae", [False,False,"Mouse-deer / Chevrotain"])
cutName("Moschidae")
cutName("Capreolus", [False,False,"Roe Deer"])
cutName("Pudu", [False,False,"Pudu"])
cutName("Mazama", [False,False,"Brocket : Chunyi"])
cutName("Muntiacus", [False,False,"Muntjac"])
cutName("Taurotragus", [False,False,"Eland"])
cut(9025, [False,False,"Anoa / Sapiutan / Midget Buffalo"])
cutName("Bison", [False,False,"Bison"])
cutName("Redunca", [False,False,"Reedbuck : Rietbok"])
cut(8905, [False,False,"Lechwe"])
cutName("Clade11001_", [False,"Cephalophinae","Duiker"])
cutName("Raphicerus", [False,False,"Grysbok, Steenbok / Steinbuck"])
cutName("Saiga", [False,False,"Saiga"])
cutName("Procapra", [False,False,"Gazelle : Goa, Dzeren"])
cutName("Clade15014_", [False,"Gazella_and_Nanger_and_Eudorcas","Gazelle : Chinkara"])
cutName("Oryx", [False,False,"Oryx, Gemsbok"])
cutName("Alcelaphus", [False,False,"Hartebeest"])
cutName("Connochaetes", [False,False,"Wildebeest"])
cutName("Rupicapra", [False,False,"Chamois"])
cutName("Ovis", [False,False,"Sheep : Argali, Mouflon, Urial"])
cutName("Pseudois", [False,False,"Bharal"])
cutName("Hemitragus", [False,False,"Tahr"])
cut(9004, [False,"Capricornis_and_Nemorhaedus_and_Ovibos","Serow, Goral, Muskox"])

#Changes to Odd-toed Ungulates
cut(7554, [False,"Hippotigris_and_Dolichohippus","Zebra"])
cutName("Tapiridae")
cutName("Rhinocerotidae")
cutName("PHOLIDOTA", [False,"Pholidota","Pangolin / Scaly Anteater / Trenggiling"])

#Changes to Carnivorans
cutName("Clade2099_", [False,"Viverridae","Civet, Genet, Lisang, Binturong / Bearcat"])
cutName("Clade1637_", [False,"Herpestidae","Mongoose, Kusimanse : Meerkat / Suricate"])
cutName("Lynx", [False,False,"Lynx : Bobcat"])
#cutName("Felis", [False,False,"Cat : Domestic Cat"])
cut(7761, [False,"Hyaeninae","Hyaena"])
cutName("Arctocephalus", [False,"Arctocephalinae","Fur Seal"])
cut(7650, [False,"Otariinae","Sea Lion"])
cutName("Monachus", [False,False,"Monk Seal"])
cutName("Mirounga", [False,False,"Elephant Seal"])
cutName("Bassaricyon", [False,False,"Olingo"])
cut(7632, [False,"Nasua_and_Nasuella","Coati"])
cutName("Procyon", [False,False,"Racoon"])
cutName("Melogale", [False,False,"Ferret-badger"])
cutName("Spilogale", [False,False,"Spotted Skunk"])
cutName("Conepatus", [False,False,"Hog-nosed Skunk"])
cutName("Mydaus", [False,False,"Stink-badger : Pantot, Teledu"])
cutName("Martes", [False,False,"Marten : Fisher, Sable"])
cutName("Clade5748_", [False,"Lutrinae","Otter"])
cutName("Galictis", [False,False,"Grison / South American Wolverine"])


#Changes to Bats
cutName("Pteralopex")
cutName("Nyctimene", [False,False,"Tube-nosed Bat / Tube-nosed Fruit Bat"])
cutName("Murina", [False,False,"Tube-nosed Bat : Flute-nosed Bat"])
cutName("Dyacopterus", [False,False,"Dyak Fruit Bat : Dayak Fruit Bat"])
cutName("Ptenochirus", [False,False,"Musky Fruit Bat"])
cutName("Myonycteris", [False,False,"Collared Fruit Bat"])
cutName("Rousettus", [False,False,"Rousette : Egyptian Fruit Bat"])
cutName("Epomops", [False,False,"Epauletted Fruit Bat : Dobson's Fruit Bat"])
cutName("Epomophorus", [False,False,"Epauletted Fruit Bat"])
cutName("Micropteropus", [False,False,"Dwarf Epauletted Fruit Bat : Hayman's Epauletted Fruit Bat"])
cutName("Eonycteris")
cutName("Harpyionycteris", [False,False,"Harpy Fruit Bat"])
cutName("Dobsonia", [False,False,"Bare-backed Fruit Bat / Naked-backed Fruit Bat"])
cutName("Pteropus", [False,False,"Flying Fox : Ceram Fruit Bat, Livingstone's Fruit Bat, Mariana Fruit Bat, Seychelles Fruit Bat"])
cutName("Saccolaimus", [False,False,"Pouched Bat, Sheath-tailed Bat : Sheathtail, Pouched Tomb Bat"])
cutName("Taphozous", [False,False,"Sheath-tailed Bat, Tomb Bat"])
cut(8048, [False,"Emballonura_and_Coleura","Sheath-tailed Bat"])
cutName("Diclidurus")
cutName("Saccopteryx")
cutName("Centronycteris", [False,False,"Shaggy Bat"])
cutName("Balantiopteryx", [False,False,"Sac-winged Bat"])
cutName("Peropteryx", [False,False,"Dog-like Bat : Peters' Sac-winged Bat"])
cutName("Rhinopomatidae")
cutName("Megaderma", [False,False,"False Vampire (Bat)"])
cutName("Nycteridae", [False,False,"Slit-faced Bat, Hollow-faced Bat"])
cutName("Rhinolophidae", [False,"Rhinolophus"])
cutName("Hipposideridae", [False,False,"(Old World) Leaf-nosed Bat, Trident Bat, Roundleaf Bat : Flower-faced Bat"])
cutName("Thyropteridae", [False,False,"Disk-winged Bat"])
cutName("Natalidae")
cutName("Noctilionidae", [False,False,"Bulldog Bat / Fisherman Bat"])
cutName("Mormoops", [False,False,"Ghost-faced Bat"])
cutName("Pteronotus", [False,False,"Mustached Bat, Naked-backed Bat"])
cutName("Desmodontinae")
cutName("Lonchorhina")
cutName("Macrotus", [False,False,"Leaf-nosed Bat"])
#cutName("Micronycteris") #Big-eared Bat
cutName("Clade11050_", [False,"Lophostoma_and_Tonatia"])
cutName("Phyllostomus", [False,False,"Spear-nosed Bat"])
cutName("Phyllonycterinae")
cutName("Lonchophylla", [False,False,"Nectar Bat, Long-tongued Bat"])
cutName("Leptonycteris", [False,False,"Long-nosed Bat"])
cutName("Monophyllus", [False,False,"Single-leaf Bat / Antillean Long-tongued Bat"])
cutName("Glossophaga")
cutName("Anoura", [False,False,"Tailless Bat : Tube-lipped Nectar Bat"])
cutName("Choeroniscus", [False,False,"Long-tailed Bat : Lesser Long-tongued Bat"])
cutName("Rhinophylla", [False,False,"Little Fruit Bat"])
cutName("Carollia", [False,False,"Short-tailed Bat / Short-tailed Fruit Bat / Short-tailed Leaf-nosed Bat"])
cutName("Sturnira")
cutName("Uroderma", [False,False,"Tent-making Bat"])
cutName("Platyrrhinus")
cutName("Chiroderma")
cutName("Vampyressa")
cutName("Artibeus", [False,False,"Fruit-eating Bat"])
cutName("Mystacina")
cutName("Molossidae", [False,False,"Free-tailed Bat, Mastiff Bat, Dog-faced Bat, Bonneted Bat : Railer Bat, Blunt-eared Bat, Broad-eared Bat, Broad-tailed Bat, Flat-headed Bat, Goblin Bat, Naked Bat"])
#cutName("Eumops", [False,False,"Bonneted Bat, Mastiff Bat"])
#cutName("Mops", [False,False,"Free-tailed Bat : Railer Bat"])
#cutName("Chaerephon", [False,False,"Free-tailed Bat, Mastiff Bat"])
#cutName("Molossus", [False,False,"Mastiff Bat : Velvety Free-tailed Bat"])
#cutName("Otomops", [False,False,"Free-tailed Bat, Mastiff Bat"])
#cutName("Promops", [False,False,"Mastiff Bat"])
#cutName("Nyctinomops", [False,False,"Free-tailed Bat : Broad-eared Bat / Broad-tailed Bat"])
#cutName("Tadarida", [False,False,"Free-tailed Bat : New Guinea Mastiff Bat"])
#cutName("Clade4040_", [False,"Molossops_and_Cynomops"])
cutName("Miniopterus", [False,False,"Long-winged Bat, Long-fingered Bat, Bent-wing Bat"])
cutName("Scotorepens")
cutName("Chalinolobus", [False,False,"Wattled Bat, Pied Bat : New Zealand Long-tailed Bat"])
cutName("Scotoecus", [False,False,"Lesser House Bat : Desert Yellow Bat"])
cutName("Scotophilus", [False,False,"Yellow Bat / Yellow House Bat"])
cutName("Glischropus", [False,False,"Thick-thumbed Bat"])
cutName("Histiotus", [False,False,"Big-eared Brown Bat"])
#cutName("Nyctophilus") #Long-eared Bat
#cutName("Laephotis", [False,False,"Long-eared Bat"])
cutName("Rhogeessa")
cutName("Dasypterus")
cutName("Barbastella", [False,False,"Barbastelle"])
#cutName("Corynorhinus", [False,False,"Big-eared Bat / Lump-nosed Bat / American Long-eared Bat"])
#cutName("Plecotus", [False,False,"Big-eared Bat, Long-eared Bat"])
cutName("Tylonycteris", [False,False,"Bamboo Bat"])
cutName("Vespadelus", [False,False,"Forest Bat, Cave Bat : Yellow-lipped Bat"])
cutName("Harpiocephalus", [False,False,"Hairy-winged Bat"])
cutName("Phoniscus", [False,False,"Trumpet-eared Bat : Groove-toothed Bat, Golden-tipped Bat"])
cutName("Kerivoula", [False,False,"Woolly Bat : Painted Bat, St. Aignan's Trumpet-Eared Bat"])


#Changes to Lemurs, Primates, etc.
#cut(7183, [3607543,"Hapalemur_and_Prolemur","Bamboo Lemur / Gentle Lemur : Bandro"])
cutName("Colobina", [False,"Colobus","Colobus : Guereza"])
cutName("Rhinopithecus")
cutName("Pygathrix", [False,False,"Douc Langur"])
cutName("Miopithecus", [False,False,"Talapoin"])
cutName("Papio", [False,False,"Baboon"])
cutName("Cercocebus", [False,False,"(White-eyelid) Mangabey"])
cutName("Lophocebus", [False,False,"(Crested) Mangabey"])
#cutName("Presbytina", [False,False,"Surili, Langur, Lutung, Leaf Monkey : Joja, Proboscis Monkey, Long-Nosed Monkey, Snub-nosed Monkey
cut(7489, [False,"Presbytis_comata","Javan Surili"])
nodeLabel(7458,[False,"Cercopithecinae"])
nodeLabel(7464,[False,False,"Hanuman Langur, etc."])

#Changes to Pikas, Rabbits, etc.
cutName("Ochotonidae", [False,False,"Pika"])
cutName("Pronolagus", [False,False,"Red Rock Hare"])
cut(7081, [False,False,"Brush Rabbit"])
cutName("Lepus", [False,False,"Hare, Jackrabbit"])

#Changes to Rodents
cutName("Gliridae", [False,False,"Dormouse : Namtap"])
cutName("Heliosciurus")
cutName("Tamias", [False,False,"Chipmunk"])
cutName("Ammospermophilus")
cutName("Cynomys")
cutName("Marmota", [False,False,"Marmot : Woodchuck / Groundhog / Whistlepig"])
cutName("Spermophilus", [False,False,"Ground Squirrel, Rock Squirrel, Suslik"])
cutName("Xerus", [False,False,"(African) Ground Squirrel"])
cutName("Paraxerus", [False,False,"(African) Bush Squirrel : Cooper's Mountain Squirrel"])
cutName("Funisciurus", [False,False,"African Striped Squirrel / Rope Squirrel : Carruther's Mountain Squirrel"])
cutName("Sciurotamias", [False,False,"Rock Squirrel"])
cutName("Tamiops", [False,False,"(Asiatic) Striped Squirrel"])
cutName("Prosciurillus", [False,False,"Dwarf Squirrel, Sanghir Squirrel"])
#cutName("Lariscus", [False,False,"Three-striped Squirrel, Ground Squirrel"])
cutName("Exilisciurus")
cutName("Ratufa", [False,False,"(Oriental) Giant Squirrel"])
cutName("Microsciurus")
cutName("Clade5664_", [23775,"Pteromyini","Flying Squirrel"])
cutName("Anomaluridae", [False,False,"Scaley-tailed Squirrel, Flying Squirrel : Scaley-tail, Flying Mouse"])
cutName("Pedetidae", [False,False,"Springhare, Springhaas"])
cutName("Octodon", [False,False,"Degu"])
cutName("CTENODACTYLOMORPHI", [False,"Ctenodactylidae","Gundi / Comb Rat : Pectinator"])
cutName("Ctenomyidae", [False,False,"Tuco-tuco : Cujuchi"])
cutName("Cuniculidae", [False,False,"Paca"])
cutName("Sphiggurus", [False,False,"Dwarf Porcupine"])
cutName("Thryonomyidae", [False,False,"Cane Rat"])
cutName("Myoprocta", [False,False,"Acouchi"])
cutName("Dasyprocta")
cutName("Clade3168_", [False,"Hydrochoerus","Capybara"])
cutName("Clade3167_", [False,"Abrocomidae","Chinchilla Rat / Chinchillone"])
cutName("Chinchillidae", [False,False,"Chinchilla, Viscacha"])
cutName("Atherurus", [False,False,"Brush-tailed Porcupine"])
cutName("Clade5652_", [False,"Caviinae","Guinea Pig, Cavy"])
cutName("Capromyidae")
cutName("Microdipodops", [False,False,"Kangaroo Mouse"])
cutName("Dipodomys", [False,False,"Kangaroo Rat"])
cutName("Brachyuromys", [False,False,"Short-tailed Rat"])
cutName("Nesomys")
cutName("Clade5620_", [False,"Rhizomyini","(Asian) Bamboo Rat"])
cutName("Tachyoryctes", [False,False,"(African) Mole-rat"])
cutName("Dactylomys", [False,False,"Bamboo Rat / Coro-coro"])
cutName("Olallamys", [False,False,"Olalla Rat"])
cutName("Clade1590_", [False,"Geomyidae","(Pocket) Gopher, Taltuza"]) 
cutName("Dipodoidea", [False,"Dipodidae","Jerboa, Jumping Mouse, Birch Mouse"])
cutName("Clade3875_", [False,"Cricetinae","Hamster"])
cutName("Macrotarsomys")
cutName("Eliurus", [False,False,"Tufted-tailed Rat"])
cutName("Steatomys")
cutName("Clade3873_", [False,"Myospalacinae","Zokor"])
cutName("Clade3874_", [False,"Arvicolinae","Vole, Lemming, Muskrat, Red Tree Mouse"])
cutName("Clade3872_", [False,"Neotomini","Packrat / Pack Rat / Woodrat, Magdalena Rat"])
cutName("Reithrodontomys")
cutName("Isthmomys", [False,False,"Isthmus Rat"])
cutName("Onychomys")
cutName("Clade4691_", [False,"Tylomyini","Climbing Rat"])
cutName("Sigmodon")
cutName("Ichthyomys")
cutName("Neusticomys")
cutName("Clade6560_", [False,"Necromys"])
cutName("Thalpomys", [False,False,"Cerrado Mouse"])
cutName("Sigmondontomys")
cutName("Nesoryzomys")
cutName("Bibimys")
cutName("Andalgalomys", [False,False,"Chaco Mouse"])
cutName("Thrichomys", [False,False,"Punare"])
cutName("Bathyergidae")
cutName("Spalax", [False,False,"(Blind) Mole Rat"])
cutName("Reithrodon", [False,False,"Conyrat : Bunny Rat"])
cutName("Oecomys", [False,False,"Arboreal Rice Rat, Unicolored Rice Rat, Long-furred Rice Rat"])
cutName("Clade6559_", [False,"Cricetomyinae","Pouched Rat, Pouched Mouse, Hamster-rat"])
cutName("Petromyscus", [False,False,"Rock Mouse, Pygmy Rock Mouse"])
cutName("Microryzomys", [False,False,"Small Rice Rat"])
cutName("Melanomys", [False,False,"Dark Rice Rat, Dusky Rice Rat"])
cutName("Clade14059_", [False,"Oryzomys","Rice Rat, Handley's Mouse"])
cutName("Clade14964_", [False,"Euneomys"])
cutName("Zygodontomys")
cutName("Eligmodontia")
cutName("Neacomys")
cutName("Clade14969_", [False,"Oxymycterus","Hocicudo"])
cutName("Calomys", [False,False,"Vesper Mouse, Laucha"])
cutName("Thomasomys")
cutName("Clade15774_", [False,"Aepeomys","Montane Mouse"])
cutName("Niviventer", [False,False,"White-Bellied Rat : Little Himalayan Rat, Limestone Rat, Long-tailed Mountain Rat, Dark-tailed Tree Rat, Smoke-Bellied Rat"])
cutName("Dasymys", [False,False,"Shaggy Rat, African Marsh Rat, Angolan Marsh Rat"])
cut(5561, [False,"Melomys_and_Protochromys_and_Paramelomys_and_Mammelomys","Mosaic-tailed Rat"])
cutName("Dendromus", [False,False,"(African) Climbing Mouse"])
nodeLabel(6642,[False,False,"Atlantic Tree Rat, etc."])
cutName("Rhipidomys")
cutName("Hyosciurus", [False,False,"Long-nosed Squirrel"])
cutName("Soricidae", [False,False,"Shrew"])
cutName("Clade935_", [False,"Galericinae","Gymnure / Moonrat / Hairy Hedgehog"])
cutName("Clade936_", [False,"Erinaceinae","Hedgehog"])
cutName("Talpidae", [False,False,"Mole, Desman, Shrew Mole"])
cutName("Apomys", [False,False,"Apomys"])
cutName("Rhynchomys", [False,False,"Rhynchomys"])
cutName("Chrotomys", [False,False,"Chrotomys"])
cutName("Hylomyscus", [False,False,"Hylomyscus"])
cutName("Bunomys")
cutName("Delomys", [False,False,"Atlantic Forest Rat"])
cutName("Clade14066_", [False,"Akadon_and_Abrothrix_and_Deltamys_and_Thaptomys","Grass Mouse, Akodont"])
cutName("Scotinomys", [False,False,"Brown Mouse"])
cutName("Acomys")
cutName("Scolomys")
cutName("Funambulus", [False,False,"Jungle Squirrel, Palm Squirrel, Striped Squirrel : Ghats Squirrel"])
cutName("Zyzomys", [False,False,"Rock Rat / Thick-tailed Rat : Kodjperr, Australian Native Mouse"])
cutName("Aconaemys")
cut(5401, [False,"Aethomys","Rock Rat / Bush Rat / Rock Mouse / Veld Rat"])
cutName("Isothrix")
cutName("Calomyscidae", [False,False,"Mouse-like Hamster / Calomyscus / Brush-tailed Mouse"])
cutName("Arvicanthis", [False,False,"(Unstriped) Grass Rat / Kasu Rat"])
cutName("Rhabdomys", [False,False,"Four-striped Grass Rat / Four-striped Grass Mouse"])
cutName("Lemniscomys", [False,False,"Striped Grass Mouse / Zebra Mouse"])
cutName("Bandicota", [False,False,"Bandicoot Rat : Sind Rice Rat / Indian Mole-rat"])
cutName("Nesokia", [False,False,"Short-tailed Bandicoot Rat"])
cutName("Berylmys")
cutName("Apodemus", [False,False,"(Eurasian) Field Mouse : Wood Mouse, Yellow-necked Mouse"])
cut(5193, [False,"Mastomys","Multimammate Mouse"])
cutName("Phloeomys", [False,False,"Giant Cloud Rat / Slender-tailed Cloud Rat"])
cutName("Crateromys", [False,False,"(Bushy-tailed) Cloud Rat"])
cutName("Carpomys", [False,False,"Luzon Tree Rat / Dwarf Cloud Rat"])
cutName("Batomys", [False,False,"Hairy-tailed Rat : Luzon Forest Rat"])
cutName("Nectomys", [False,False,"Water Rat : Amazonian Mouse / Small-footed Bristly Mouse"])
cutName("Hydromys", [False,False,"Water Rat : Rakali / Rabe"])
cutName("Sigmodontomys")
cutName("Chelemys", [False,False,"Long-clawed Mouse / Long-clawed Akodont"])
cutName("Lophuromys", [False,False,"Brush-furred Mouse / Brush-furred Rat / Harsh-furred Rat / Course-haired Mouse"])
cutName("Pelomys")
cutName("Rheomys")
cutName("Leopoldamys", [False,False,"Long-tailed Giant Rat : Edward's Rat"])
cutName("Solomys", [False,False,"Giant Rat / Naked-tailed Rat"])
cut(5508, [False,"Praomys","Soft-furred Mouse"])
cutName("Mallomys")

##########################################################

#Final Processing
used()
#for i in range(1,len(Li)):
#	if not(Li[i]):
#		leafs[i-1] = []
#for i in range(1,len(Ni)):
#	if not(Ni[i]):
#		nodes[i-1] = []
#print sum(Li), sum(Ni)

leafs_new = []
nodes_new = []
for wood in chop:
	if wood[0]:
		leafs_new.append(leafs[wood[3]-1])
		wood[3] = len(leafs_new)
	else:
		nodes_new.append(nodes[wood[3]-1])
		wood[3] = len(nodes_new)
while len(leafs_new)>len(nodes_new):
	nodes_new.append([])
while len(leafs_new)<len(nodes_new):
	leafs_new.append([])
leafs = leafs_new
nodes = nodes_new

js_print("mammal")