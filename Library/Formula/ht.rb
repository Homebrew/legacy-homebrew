require 'formula'

class Ht < Formula
  url 'http://dl.sourceforge.net/project/hte/ht-source/ht-2.0.18.tar.bz2'
  homepage 'http://hte.sf.net/'
  md5 '9cd5c52bb3fbae5c631875cd0de3318c'

  def install
    system "chmod +x ./install-sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
