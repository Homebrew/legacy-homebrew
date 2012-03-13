require 'formula'

class Ht < Formula
  url 'http://downloads.sourceforge.net/project/hte/ht-source/ht-2.0.19.tar.bz2'
  homepage 'http://hte.sf.net/'
  sha1 '08cc1d82b74ea646e308e7b9629b03b5b79ca419'

  depends_on 'lzo'

  def install
    system "chmod +x ./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
