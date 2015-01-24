require 'formula'

class Ht < Formula
  homepage 'http://hte.sf.net/'
  url 'https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2'
  sha256 '31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70'

  depends_on 'lzo'

  def install
    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make install"
  end
end
