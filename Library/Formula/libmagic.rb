require 'formula'

class Libmagic < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.08.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 '6a2a263c20278f01fe3bb0f720b27d4e'

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
