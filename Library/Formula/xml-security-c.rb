require 'formula'

class XmlSecurityC < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=%2Fsantuario%2Fc-library%2Fxml-security-c-1.6.1.tar.gz'
  homepage 'http://santuario.apache.org/'
  md5 '808316c80a7453b6d50a0bceb7ebe9bc'

  depends_on 'xerces-c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
