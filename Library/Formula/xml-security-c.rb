require 'formula'

class XmlSecurityC < Formula
  homepage 'http://santuario.apache.org/'
  url 'http://apache.sunsite.ualberta.ca/santuario/c-library/xml-security-c-1.7.0.tar.gz'
  sha256 'c8cd6ec3d3b777fcca295cb4b273b08e4cfe37e03fc27131ec079894b9dae87c'

  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
