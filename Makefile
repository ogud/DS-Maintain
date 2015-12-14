
all: m.txt

m.xml: CDS-maintain.md 
	~/gocode/bin/mmark -xml2 -page CDS-maintain.md > m.xml

m.txt: m.xml 
	sed -ia 's/anchors.xml/anchors-13.xml/' m.xml
	xml2rfc m.xml 

#old stuff 
x.xml: CDS-delete.md 
#	mv x.txt x.old 
	~/gocode/bin/mmark -xml2 -page CDS-delete.md > x.xml
#	~/gocode/src/github.com/miekg/mmark/mmark/mmark -xml2 

x.txt: x.xml
	sed -ia 's/anchors.xml/anchors-13.xml/' x.xml
	xml2rfc x.xml 

clean:
	/bin/rm -f *~ *#
