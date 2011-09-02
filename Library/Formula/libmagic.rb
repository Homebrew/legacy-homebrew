require 'formula'

class Libmagic < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.04.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 'accade81ff1cc774904b47c72c8aeea0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1 # Remove some warnings during install
    system "make install"

    # don't dupe this system utility and this formula is called "libmagic" not "file"
    rm bin/"file"
    rm man1/"file.1"
  end
end
