require 'formula'

class Ht < Formula
  homepage 'http://hte.sf.net/'
  url 'https://downloads.sourceforge.net/project/hte/ht-source/ht-2.0.22.tar.bz2'
  sha256 'c729d64bf7de440c7b1021d3d6657ccbdb103541b4082a58dca7c8402c773f58'

  depends_on 'lzo'

  def install
    system "chmod +x ./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make install"
  end
end
