require 'formula'

class Rpl < Formula
  url 'ftp://ftp2.laffeycomputer.com/pub/current_builds/rpl-1.4.1.tar.gz'
  homepage 'http://www.laffeycomputer.com/rpl.html'
  md5 '2eb9c18d97040dc301bfaa8aa70e21a4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
