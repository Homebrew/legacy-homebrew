require 'formula'

class Potrace < Formula
  url 'http://potrace.sourceforge.net/download/potrace-1.10.tar.gz'
  homepage 'http://potrace.sourceforge.net'
  sha1 'e6e8b64d85d30b4695d197a79187ac98c2b236f9'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
