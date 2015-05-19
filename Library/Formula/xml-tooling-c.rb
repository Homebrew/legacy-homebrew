require 'formula'

class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage 'https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C'
  url 'http://shibboleth.net/downloads/c++-opensaml/2.5.3/xmltooling-1.5.3.tar.gz'
  sha1 'b8498a8dafe18bf612a6651ab7af662add5c2a68'

  depends_on 'pkg-config' => :build
  depends_on 'log4shib'
  depends_on 'xerces-c'
  depends_on 'xml-security-c'
  depends_on 'boost'

  def install
    ENV.O2 # Os breaks the build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
