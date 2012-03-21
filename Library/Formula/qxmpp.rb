require 'formula'

class Qxmpp < Formula
  url 'http://qxmpp.googlecode.com/files/qxmpp-0.3.92.tar.gz'
  homepage 'http://qxmpp.googlecode.com/'
  md5 'c43c6b529771ac74778bb071e4ae0fd8'

  depends_on 'qt'

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
