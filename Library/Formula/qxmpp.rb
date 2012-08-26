require 'formula'

class Qxmpp < Formula
  homepage 'https://code.google.com/p/qxmpp/'
  url 'http://qxmpp.googlecode.com/files/qxmpp-0.6.3.tar.gz'
  sha1 '51eb686677b26fa2fd756bc755956c0bf84193ea'

  depends_on 'qt'

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
