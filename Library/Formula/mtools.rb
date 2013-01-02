require 'formula'

class Mtools < Formula
  url 'ftp://ftpmirror.gnu.org/mtools/mtools-4.0.17.tar.gz'
  mirror 'ftp://ftp.gnu.org/gnu/mtools/mtools-4.0.17.tar.gz'
  homepage 'http://www.gnu.org/software/mtools/'
  sha1 'eebfab51148c4ab20a6aca3cea8057da5a11bdc8'

  def install
    system "./configure", "LIBS=-liconv", "--disable-debug",
                          "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
