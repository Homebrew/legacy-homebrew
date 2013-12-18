require 'formula'

class Rpl < Formula
  homepage 'http://www.laffeycomputer.com/rpl.html'
  url 'ftp://ftp2.laffeycomputer.com/pub/current_builds/rpl-1.4.1.tar.gz'
  sha1 '6c67ecd2307f378b44b697411b0ab65bc5d2cdaa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
