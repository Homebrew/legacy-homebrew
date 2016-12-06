require 'formula'

class XmlSecurityC < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=%2Fsantuario%2Fc-library%2Fxml-security-c-1.6.1.tar.gz'
  homepage 'http://santuario.apache.org/'
  sha1 '239304659752eb214f3516b6c457c99f0e6467c7'

  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
