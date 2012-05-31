require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.11.tar.gz'
  sha1 'df8ffe8759ec8cd85a98dc98e858563ea2555f64'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
