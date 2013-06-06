require 'formula'

class Gengetopt < Formula
  homepage 'http://www.gnu.org/software/gengetopt/'
  url 'http://ftpmirror.gnu.org/gengetopt/gengetopt-2.22.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gengetopt/gengetopt-2.22.6.tar.gz'
  sha1 'c93bdec17f247aa32b3cd6530a6f68aa430d67f5'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV.deparallelize
    system "make install"
  end
end
