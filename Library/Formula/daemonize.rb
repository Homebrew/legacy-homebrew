require 'formula'

class Daemonize < Formula
  url 'https://github.com/bmc/daemonize/tarball/release-1.7.0'
  homepage 'http://software.clapper.org/daemonize/'
  md5 '192ac89303695d0019bdc27610703dca'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
