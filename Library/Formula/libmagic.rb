require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.10.tar.gz'
  sha1 '72fd435e78955ee122b7b3d323ff2f92e6263e89'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"

    # don't dupe this system utility and this formula is called "libmagic" not "file"
    rm bin/"file"
    rm man1/"file.1"
  end
end
