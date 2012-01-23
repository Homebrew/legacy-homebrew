require 'formula'

class Libmagic < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.09.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 '6fd7cd6c4281e68fe9ec6644ce0fac6f'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Remove some warnings during install
    system "make install"

    # don't dupe this system utility and this formula is called "libmagic" not "file"
    rm bin/"file"
    rm man1/"file.1"
  end
end
