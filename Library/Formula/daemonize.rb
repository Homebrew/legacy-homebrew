require 'formula'

class Daemonize < Formula
  homepage 'http://software.clapper.org/daemonize/'
  url 'https://github.com/bmc/daemonize/tarball/release-1.7.3'
  sha1 'c394ecb6e3db00d721e88a35a298a0a6dce6b133'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
