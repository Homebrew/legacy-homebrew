require 'formula'

class Ht < Formula
  url 'http://downloads.sourceforge.net/project/hte/ht-source/ht-2.0.18.tar.bz2'
  homepage 'http://hte.sf.net/'
  md5 '9cd5c52bb3fbae5c631875cd0de3318c'

  depends_on 'lzo'

  def install
    system "chmod +x ./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
