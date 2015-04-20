require 'formula'

class XmlSecurityC < Formula
  homepage 'http://santuario.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-1.7.2.tar.gz'
  sha1 'fee59d5347ff0666802c8e5aa729e0304ee492bc'

  bottle do
    cellar :any
    sha1 "2d08293634c4b7ff1e5794dcdee9845f35ca13c9" => :yosemite
    sha1 "82e9096d90dbdcc4edb2043af3c0361787b65a57" => :mavericks
    sha1 "2ca2c2af28a4d7e45bb54110054323a7e220c47b" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
