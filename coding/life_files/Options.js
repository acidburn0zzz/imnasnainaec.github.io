var sensitivity=0.84;
var sensitivity3=0.9;
var sensitivity2=0.88;
var threshold=0.75;
var thresholdtxt=1.2;
var thresholdnode=70;
var drawsignposts=true;
var aboutHTML="<p>This version of the mammal branch of the <a href='http://www.onezoom.org/life.html' target='_blank'>OneZoom tree of life</a> was customized by Danny Rorabaugh. At the cost of species distinction, the present tree gives a more user-friendly presentation of mammals labeled by their common names. For examples, when all the species in a taxon (such as the family Tachyglossidae, the order Paucituberculata, or the genus Planigale) are named by the same noun with different adjectives, those species are condensed into a single leaf. Then every leaf has a hyperlink to the cooresponding Wikipedia page for those who desire more detail. This effort is made more complicated where common naming conventions do not align with modern genetic classification. For more detail on the decisions made and notation used for this tree, select \"How to use\" from the main menu. Text below is carried over from the original <a href='http://www.onezoom.org/life.html' target='_blank'>OneZoom tree of life</a> with minor modification.</p>"
 + "<h2>About the OneZoom tree of life</h2>"
  + "<p class='intro'>We hope you have fun exploring the OneZoom tree of life - we've certainly had fun developing it.  Even after thousands of hours working on it, we are still frequently astonished at what it reveals about the world around us. Here are some details about how it all works &mdash;</p>"
  + "<h3>Software</h3><p>The OneZoom software uses fractals to condense the entire tree of life into a single, zoomable page. OneZoom® is so named because all the information is on a single page: all you have to do is zoom to reveal details. To find out about its gradual development, see our <a href='http://www.onezoom.org/milestones.html' target='_blank'>timeline</a>. <img class='rt_edge' src='http://www.onezoom.org/static/images/leaves/Rpic3.png' />Or find out how you can use OneZoom on your own website, for research or education, by going to our <a href='http://www.onezoom.org/developer.html' target='_blank'>developer page</a> where a suite of software is available for reuse under an open source MIT license.</p>"
  + "<h3>The tree of life</h3><p>The data used to construct the tree is from a hand-crafted mix of sources, but relies heavily on the <a href='http://www.opentreeoflife.org' target='_blank'>Open Tree of Life</a> project, to whom we are extremely grateful. For further, extensive information and references, select <q>Data sources<q>. If you are an expert on certain species, we encourage you to <a href='http://tree.opentreeoflife.org/curator' target='_blank'>contribute data</a> to the OpenTree project. </p>"
  + "<h3>Images</h3><p>Images of species on the tree have been harvested from the internet by the <a href='http://eol.org/' target='_blank'>Encyclopedia of Life</a> project (EoL). We have only selected images that are in the public domain, or released under a <a href='http://creativecommons.org' target='_blank'>Creative Commons</a> license. For further information on any image, zoom into the copyright symbol next to the picture. The symbol also serves as a link to the source of the image on EoL. We must thank EoL for their fantastic resource, and helpful responses to our various requests.</p>"
  + "<h3>Conservation status</h3><p>In the current version, the red leaves of the tree correspond to species that are threatened with extinction according to the <a href='http://www.iucnredlist.org' target='_blank'>IUCN Red List</a> of threatened species. <img class='rt_edge' src='http://www.onezoom.org/static/images/leaves/Rpic4.png' />Formally, these species are categorised as <a href='http://www.iucnredlist.org/static/categories_criteria_3_1#categories' target='_blank'>vulnerable, endangered, or critically endangered</a>.</p>"
  + "<h3>People and thanks</h3><p>The current version of software has been developed jointly by Dr James Rosindell, who primarily worked on visualisation and Dr Yan Wong, who primarily worked on synthesising the tree data. Yan is a coauthor with Professor Richard Dawkins on <a href='http://www.ancestorstale.net' target='_blank'><i>The Ancestor's Tale</i></a>: a history of life which has made extensive use of the OneZoom visualisations. The research done for the book has in turn contributed to the dataset used by the OneZoom software. James originally devised the OneZoom concept in 2011 which was published with Dr. Luke Harmon in 2012. Since then Kai Zhong has also had significant input into the OneZoom codebase that this software is based on. More details about the OneZoom software, charity and the many people involved can be found on our <a href='http://www.onezoom.org/about.html' target='_blank'>about page</a>.</p>";
var howHTML=
 "<h2>How to use this tree</h2>"
  + "<p>Each leaf represents a different taxon or species and the branches show how they are genetically/evolutionarily related.</p>"
  + "<p>This tree of life is explored like you would a map, just zoom in to your area of interest to reveal further details. To zoom you can scroll with your mouse or trackpad or click the + and - buttons. </p>"
  + "<p>The search icon (second from the left) gives you an easy way to search or go straight to recommended areas of the tree. </p>"
  + "<p> The location icon (third from the left) shows you which part of the tree of life you are looking at in the context of all mammalian life. </p>"
  + "<p> If a leaf is coloured red, this means the species it represents is known to be threatened with extinction.</p>"
 + "<h2>Notation used in this tree</h2>"
  + "<p>As pluralization rules in English are often quite complicated, only the sigular form of nouns are used here. So when using the search feature, make sure to type, for example, \"mouse\" instead of \"mice\" and \"dassy\" instead of \"dassies\".</p>"
  + "An effort has been made to combine related species with a common name into a single leaf to eliminate an overload of adjectives. Where distinction neccessitates, adjectives are retained to prevent ambiguity. For example, only a few species of hare are found outside the genus Lepus, so the hispid hare and the red rock hares are the only hares found outside of the \"Hare, Jackrabbit\" leaf."
  + "<p>Sometimes a single species or taxon has multiple common names, which we separate with a forward slash (/). For example, a member of the family Tachyglossidae is called either an echidna or a spiney anteater, so the cooresponding leaf is labeled \"Echidna / Spiny Anteater\".</p>"
  + "<p>When a taxon consists of a complicated mix of species that go by several--possibly overlapping but not synonymous--names, a comma (,) is used. For example, every member of the family Peramelidae is called a bandicoot, but every New Guinean spiny bandicoots also has a common name derived from prepending an adjective to its genus name. Thus the corresponding leaf is labeled \"Bandicoot, Echymipera\". Another example is the suborder Phalangeriformes whose leaf is labeled \"Possum, Glider, Cuscus, Triok\" in which some gliders are more closly related to the trioks than to other gliders and the relation between varietes of possum and genuses containing the other three names are also rather mixed.</p>"
  + "<p>Sometimes one or two species within a taxon will have a distinct name. A colon (:) will indicate such a distinction. Names before (to the left of) a colon apply to many of the species within a taxon or all the species of a specific subgroup of the taxon. Names after (to the right of) a colon will apply to one or two specific species that fall under at least one name found before the colon. For example, a member of any of the four species within the genus Lynx can be referred to as a lynx, but since a member of the species Lynx rufus is also called a bobcat, the leaf is labeled \"Lynx : Bobcat\". Another example is the ganus Mydaus labeled \"Stink-badger : Pantot, Teledu\" because a Palawan stink badger is also called a pantot and a Sunda/Java/Malay stink badger is also called a teledu. We combine two single-species leaves into one two-species leaf to avoid having \"Stink Badger\" appear four times with the various possible adjectives. </p>"
  + "<p>Parentheses are used around terms that may be left off in common names or common speech. For example, a member of the species Felis catus is a domestic cat, but is usually just called a cat, so the leaf is labeled \"(Domestic) Cat\". Also, a member of the genus Dendromus in general is called an African climbing mouse, but 'African' only appears in the name of one of the dozen relevant species, so the leaf is labeled \"(African) Climbing Mouse\".</p>";
  + "<p>For more information on the animal(s) of a given leaf, just click the Wikipedia link.</p>"
var dataHTML=
 '<h2>List of data sources</h2>'
  + '<p>[Text below is carried over from the original <a href="http://www.onezoom.org/life.html" target="_blank">OneZoom tree of life</a> with minor modification. Comments in square brackets are added by Danny.]</p>'
  + '<h3>Images</h3><p>Images of organisms have all been taken from the <a href="http://eol.org" target="_blank">Encylopedia of Life</a>, and are variously in the public domain, or can be reused under the <a href="http://creativecommons.org" target="_blank">Creative Commons</a> attribution-only or attribution + share-alike licences. To see the source for any image, zoom in to the copyright symbol at the lower right, or click on the symbol to go to the the Encylopedia of Life page from where more information can be obtained.</p>'
  + '<h3>Evolutionary Trees</h3><p><a href="http://www.opentreeoflife.org" target="_blank"><img src="http://www.onezoom.org/static/images/Open-Tree-of-Life-Logo.png" alt="" /></a>Species have been grafted onto this backbone using a large number of studies of various groups or organisms. In particular, many studies have been collected by the <a href="http://www.opentreeoflife.org" target="_blank">Open Tree of Life</a> project, an <a href="http://www.pnas.org/content/112/41/12764" target="_blank">ambitious attempt</a> to unify scientific studies into a comprehensive evolutionary tree of all known species of life on earth. This provides comprehensive coverage of approximately 2.5 million species, but the current draft version contains some problematic arrangements of relationships between higher-level groups (we encourage evolutionary scientists to <a href="https://tree.opentreeoflife.org/curator" target="_blank">add data to the OpenTree</a>, from where it will eventually percolate down into the OneZoom software). </p><p>For added accuracy, and to provide a few divergence dates, the <a href="http://www.onezoom.org/" target="_blank">OneZoom</a> site relies on the additional studies listed below for specific areas of the tree of life. Where possible, the OpenTree (<a href="http://files.opentreeoflife.org/synthesis/opentree5.0" target="_blank">version 5</a>)  has been used to supplement these studies to include most or all currently recognized species. Note that the OneZoom display currently requires all branches to split in two (bifurcations), rather than simultanously splitting into 3 or more branches (technically known as polytomies). Where polytomies exist in the trees used, the OneZoom software split them randomly into bifurcations.</p><ul>'
   + '<li><img src="http://www.onezoom.org/static/FinalOutputs/pics/26793963.jpg" alt="" /><strong>Mammals</strong>: the entire tree is from Bininda-Emonds <i>et al.</i> (2007) <i>The delayed rise of present-day mammals.</i> <a href="http://www.nature.com/nature/journal/v446/n7135/full/nature05634.html" target="_blank">Nature <b>446</b>: 507-512</a>, with the exception of:<ul>'
    + '<li><img src="http://www.onezoom.org/static/FinalOutputs/pics/26811783.jpg" alt="" /><strong>Marsupials</strong>: orders arranged according to Nilsson <i>et al.</i> (2010) <i>Tracking Marsupial Evolution Using Archaic Genomic Retroposon Insertions.</i> <a href="http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1000436" target="_blank">PLoS Biology: <b>8</b>: e1000436</a>.</li>'
	+ '<li><img src="http://www.onezoom.org/static/FinalOutputs/pics/26808924.jpg" alt="" /><strong>Placental mammals</strong>: afrotheres and xenarthrans are grouped together (the <q>atlantogenata</q> hypothesis) on the basis of Poulakakis &amp; Stamatakis (2010) <i>Recapitulating the evolution of Afrotheria: 57 genes and rare genomic changes (RGCs) consolidate their history.</i> <a href="http://dx.doi.org/10.1080/14772000.2010.484436" target="_blank">Systematics and Biodiversity: <b>8</b> 395-408</a>.</li>'
	+ '<li><img src="http://www.onezoom.org/static/FinalOutputs/pics/26836324.jpg" alt="" /><strong>Cetartiodactyla</strong>: placement is taken from dos Reis <i>et al.</i> (2012) <i>Phylogenomic datasets provide both precision and accuracy in estimating the timescale of placental mammal phylogeny</i>. <a href="http://rspb.royalsocietypublishing.org/content/279/1742/3491.long" target="_blank">Proceedings of the Royal Society B: Biological Sciences <b>279</b>: 3491-3500</a>.</li>'
	+ '<li><img src="http://www.onezoom.org/static/FinalOutputs/pics/26805785.jpg" alt="" /><strong>Colugos</strong> from Janečka <i>et al.</i> (2008) <i>Evidence for multiple species of Sunda colugo.</i> <a href="http://www.sciencedirect.com/science/article/pii/S0960982208011901" target="_blank">Current Biology<b>18</b>: R1001-R1002</a>.</li>'
	+ '<li><img src="http://www.onezoom.org/static/FinalOutputs/pics/31340940.jpg" alt="" /><strong>Primates</strong>: entire tree from Springer <i>et al.</i> (2012) <i>Macroevolutionary dynamics and historical biogeography of primate diversification inferred from a species supermatrix</i>. <a href="http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0049521" target="_blank">PLoS ONE <b>7</b>: e49521</a> (supplementary information text s2), with the exception of:<ul><li><img src="http://www.onezoom.org/static/FinalOutputs/pics/26838690.jpg" alt="" /><b>Gibbons</b>: arrangements of the 4 genera taken from Carbone <i>et al.</i> (2014) <i>Gibbon genome and the fast karyotype evolution of small apes.</i> <a href="http://www.nature.com/nature/journal/v513/n7517/full/nature13679.html" target="_blank">Nature <b>513</b>: 195-201</a>.</li></ul></li>'
   + '</ul></li>'
  + '</ul>'
  + '<br><br>[<a href="http://www.wikipedia.org" target="_blank">Wikipedia</a> was a sorce for additional taxon and species names beyond those found in the original OneZoom.]<br>'
//  + '<h3>Dates on the OneZoom tree</h4><p>Dates are taken from <a href="http://www.ancestorstale.net" target="_blank">The Ancestor&#39;s Tale (2nd edition)</a>, which provides a detailed explanation in the endnotes about the dating techniques used. [Dates have been knocked out of whack in Danny\'s editing. He intends to fix them eventually.]</p>';