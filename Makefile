
all: x.txt y.txt

x.xml: CDS-delete.md 
#	mv x.txt x.old 
	~/gocode/src/github.com/miekg/mmark/mmark/mmark -xml2 -page CDS-delete.md > x.xml

x.txt: x.xml
	sed -ia 's/anchors.xml/anchors-13.xml/' x.xml
	xml2rfc x.xml 

y.txt: y.xml 
	sed -ia 's/anchors.xml/anchors-13.xml/' y.xml
	xml2rfc y.xml 

y.xml: CDS-maintain.md 
	~/gocode/src/github.com/miekg/mmark/mmark/mmark -xml2 -page CDS-maintain.md > y.xml


clean:
	/bin/rm -f *~ *#
