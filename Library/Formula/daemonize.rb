require 'formula'

class Daemonize <Formula
  url 'https://github.com/bmc/daemonize/tarball/release-1.6.1'
  homepage 'http://bmc.github.com/daemonize/'
  md5 'bee4b67382f9969cae72b06038a4ae8e'
  version '1.6.1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
