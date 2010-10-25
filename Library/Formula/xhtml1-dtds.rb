require 'formula'

class Xhtml1Dtds <Formula
  url 'http://www.w3.org/TR/2002/REC-xhtml1-20020801/xhtml1.tgz'
  homepage 'http://www.w3.org/TR/2002/REC-xhtml1-20020801/'
  sha256 '148e9eccb5c91222b5f0c07359174ca0df1bd74834a2bae4c6e57c10136a2067'

  def install
    # The XHTML1 DTDs need to be placed in a directory, after extracting
    # them from the w3's downloadable tarball.  Then we set up an XML
    # catalog file, so other packages can use them

    # First create a variable containing the name of the directory for
    # installing things in
    xhtml_dir = share+"xhtml1-dtds-1.0"

    # Use the new variable to create the directory
    xhtml_dir.mkpath

    # Copy the XHTML1 DTD files into the directory
    Dir.chdir "DTD" do
      xhtml_dir.install %w(xhtml1.dcl xhtml1-frameset.dtd xhtml1-strict.dtd
                           xhtml1-transitional.dtd xhtml-lat1.ent xhtml.soc
                           xhtml-special.ent xhtml-symbol.ent)
    end

    # Create a brand new XML catalog file
    system "xmlcatalog --noout --create #{share}/xhtml1-dtds-1.0/catalog.xml"

    # Manipulate the new XML catalog file, creating each of the needed entries
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
