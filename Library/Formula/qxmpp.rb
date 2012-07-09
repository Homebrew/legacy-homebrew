require 'formula'

class Qxmpp < Formula
  homepage 'https://code.google.com/p/qxmpp/'
  url 'http://qxmpp.googlecode.com/files/qxmpp-0.4.0.tar.gz'
  sha1 'b42731a68ddda16aeed836d488a75331452b4d8d'

  depends_on 'qt'

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
