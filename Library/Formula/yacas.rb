require 'formula'

class Yacas < Formula
  homepage 'http://yacas.sourceforge.net'
  url 'http://yacas.sourceforge.net/backups/yacas-1.3.3.tar.gz'
  sha1 '749952102f5321d62788be8ae459c1a67078b33d'

  option "with-server", "Build the network server version"

  def install
    args = [ "--prefix=#{prefix}" ]
    args << "--enable-server" if build.with? "server"

    system "./configure", *args
    system "make install"
  end
end
