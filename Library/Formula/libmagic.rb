require 'formula'

class Libmagic < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.03.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 'd05f08a53e5c2f51f8ee6a4758c0cc53'

  def keg_only?
    "This brew provides 'libmagic', but also installs a 'file' command which shadows the OS X-provided one."
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1 # Remove some warnings during install
    system "make install"
  end
end
