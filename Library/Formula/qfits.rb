require 'formula'

class Qfits < Formula
  url 'ftp://ftp.eso.org/pub/qfits/qfits-6.2.0.tar.gz'
  homepage 'http://www.eso.org/sci/software/eclipse/qfits/index.html'
  md5 'f3920831eee308af04d75089291ce144'

  def install
    # qfits does not support 64bit build
    ENV.m32
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
