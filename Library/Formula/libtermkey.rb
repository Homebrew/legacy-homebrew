require 'formula'

class Libtermkey < Formula
  homepage 'http://www.leonerd.org.uk/code/libtermkey/'
  url 'http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.13.tar.gz'
  sha1 'f0c2ead4185095e5c87c51b1a721e211ea08bae6'

  def install
    system "make", "PREFIX=#{prefix}", "LIBTOOL=glibtool"
    system "make", "install", "PREFIX=#{prefix}", "LIBTOOL=glibtool"
  end
end
