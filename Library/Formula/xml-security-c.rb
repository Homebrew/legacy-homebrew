require 'formula'

class XmlSecurityC < Formula
  homepage 'http://santuario.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-1.7.2.tar.gz'
  sha1 'fee59d5347ff0666802c8e5aa729e0304ee492bc'

  depends_on 'pkg-config' => :build
  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
