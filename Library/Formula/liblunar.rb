require 'formula'

class Liblunar < Formula
  url 'http://liblunar.googlecode.com/files/liblunar-2.2.4.tar.gz'
  homepage 'http://code.google.com/p/liblunar/'
  md5 '6f5a7e2f79483f572af3f896c9379b0f'

  depends_on 'gettext'
  depends_on 'intltool'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
