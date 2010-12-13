require 'formula'

class XmlToolingC <Formula
  url 'http://shibboleth.internet2.edu/downloads/opensaml/cpp/latest/xmltooling-1.3.3.tar.gz'
  homepage 'https://spaces.internet2.edu/display/OpenSAML/XMLTooling-C'
  md5 '3074edc8a00bba1d26c02e798ea8039c'

  depends_on 'pkg-config' => :build
  depends_on 'log4shib'
  depends_on 'xerces-c'
  depends_on 'xml-security-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
