require 'formula'

class Mtools < Formula
  homepage 'http://www.gnu.org/software/mtools/'
  url 'ftp://ftpmirror.gnu.org/mtools/mtools-4.0.17.tar.gz'
  mirror 'ftp://ftp.gnu.org/gnu/mtools/mtools-4.0.17.tar.gz'
  sha1 'eebfab51148c4ab20a6aca3cea8057da5a11bdc8'

  depends_on :x11

  def install
    system "./configure", "LIBS=-liconv",
                          "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
