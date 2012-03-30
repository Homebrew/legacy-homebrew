require 'formula'

class Qxmpp < Formula
  homepage 'https://code.google.com/p/qxmpp/'
  url 'http://qxmpp.googlecode.com/files/qxmpp-0.3.92.tar.gz'
  sha1 'a21fbe5efc491b716d77c6796b9db560c2604525'

  depends_on 'qt'

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
