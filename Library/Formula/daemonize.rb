require 'formula'

class Daemonize < Formula
  homepage 'http://software.clapper.org/daemonize/'
  url 'https://github.com/bmc/daemonize/archive/release-1.7.4.tar.gz'
  sha1 '25465f696108f9e112039c9363aff8c798191789'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
