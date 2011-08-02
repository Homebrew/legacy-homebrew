require 'formula'

class XmlSecurityC < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=c-library/xml-security-c-1.5.1.tar.gz'
  homepage 'http://santuario.apache.org/'
  md5 '2c47c4ec12e8d6abe967aa5e5e99000c'

  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
