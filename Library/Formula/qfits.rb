require 'formula'

class Qfits < Formula
  homepage 'http://www.eso.org/sci/software/eclipse/qfits/index.html'
  url 'ftp://ftp.eso.org/pub/qfits/qfits-6.2.0.tar.gz'
  sha1 '9e05023316ebc307b8191068dc07d6fd449ac14d'

  def install
    # qfits does not support 64bit build
    ENV.m32
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
