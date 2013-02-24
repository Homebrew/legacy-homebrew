require 'formula'

class Daemonize < Formula
  homepage 'http://software.clapper.org/daemonize/'
  url 'https://github.com/bmc/daemonize/tarball/release-1.7.4'
  sha1 'b8d151773b9245f5c9e58d9ab8e9ddd665a6b668'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
