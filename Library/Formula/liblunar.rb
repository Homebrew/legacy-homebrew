require 'formula'

class Liblunar < Formula
  url 'http://liblunar.googlecode.com/files/liblunar-2.2.4.tar.gz'
  homepage 'http://code.google.com/p/liblunar/'
  sha1 '34efb18ebe827ac47da6aecef70735d5c2a6b8d4'

  depends_on 'gettext'
  depends_on 'intltool'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
