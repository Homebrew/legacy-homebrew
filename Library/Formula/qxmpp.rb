require 'formula'

class Qxmpp < Formula
  homepage 'https://code.google.com/p/qxmpp/'
  url 'http://qxmpp.googlecode.com/files/qxmpp-0.7.4.tar.gz'
  sha1 '73ead25efd41e238311aff9a566d6335c722792d'

  depends_on 'qt'

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
