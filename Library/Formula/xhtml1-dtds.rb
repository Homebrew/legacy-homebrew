require 'formula'

class Xhtml1Dtds <Formula
  url 'http://www.w3.org/TR/2002/REC-xhtml1-20020801/xhtml1.tgz'
  homepage 'http://www.w3.org/TR/2002/REC-xhtml1-20020801/'
  sha256 '148e9eccb5c91222b5f0c07359174ca0df1bd74834a2bae4c6e57c10136a2067'

  def install
    # Create the needed directory structure for the XHTML1 DTDs
    mkdir_p "#{share}/xhtml1-dtds-1.0/"

    # Copy the DTD files into place
    cp %w(DTD/xhtml1.dcl DTD/xhtml1-frameset.dtd), "#{share}/xhtml1-dtds-1.0/"
    cp %w(DTD/xhtml1-strict.dtd DTD/xhtml1-transitional.dtd), "#{share}/xhtml1-dtds-1.0/"
    cp %w(DTD/xhtml-lat1.ent DTD/xhtml.soc), "#{share}/xhtml1-dtds-1.0/"
    cp %w(DTD/xhtml-special.ent DTD/xhtml-symbol.ent), "#{share}/xhtml1-dtds-1.0/"

    # Create the XML catalog file
    system "xmlcatalog --noout --create #{share}/xhtml1-dtds-1.0/catalog.xml"

    # Create each of the needed entries in the XML catalog file
    system "xmlcatalog --noout -add public '-//W3C//DTD XHTML 1.0 Strict//EN' 'xhtml1-strict.dtd' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add public '-//W3C//DTD XHTML 1.0 Transitional//EN' 'xhtml1-transitional.dtd' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add public '-//W3C//DTD XHTML 1.0 Frameset//EN' 'xhtml1-frameset.dtd' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add public '-//W3C//ENTITIES Latin 1 for XHTML//EN' 'xhtml-lat1.ent' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add public '-//W3C//ENTITIES Special for XHTML//EN' 'xhtml-special.ent' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add public '-//W3C//ENTITIES Symbols for XHTML//EN' 'xhtml-symbol.ent' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add rewriteSystem 'http://www.w3.org/TR/xhtml1/DTD/' './' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add rewriteSystem 'http://www.w3.org/TR/2002/REC-xhtml1-20020801/DTD/' './' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add rewriteURI 'http://www.w3.org/TR/xhtml1/DTD/' './' #{share}/xhtml1-dtds-1.0/catalog.xml"
    system "xmlcatalog --noout -add rewriteURI 'http://www.w3.org/TR/2002/REC-xhtml1-20020801/DTD/' './' #{share}/xhtml1-dtds-1.0/catalog.xml"
  end
end
