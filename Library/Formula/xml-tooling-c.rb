require 'formula'

class XmlToolingC < Formula
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C'
  url 'http://shibboleth.net/downloads/c++-opensaml/2.5.2/xmltooling-1.5.2.tar.gz'
  sha256 'd43719f8d742d87131ea64f2dbc8f1b366c7f216ac21015090a51693ff11df98'

  depends_on 'pkg-config' => :build
  depends_on 'log4shib'
  depends_on 'xerces-c'
  depends_on 'xml-security-c'
  depends_on 'boost149'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
