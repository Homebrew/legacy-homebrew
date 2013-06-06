require 'formula'

class Ht < Formula
  homepage 'http://hte.sf.net/'
  url 'http://sourceforge.net/projects/hte/files/ht-source/ht-2.0.21.tar.bz2'
  sha256 'f9c04f2074d6a774bae0d7fdc3f8b2c579db39aad0761b33b4884949fc378934'

  depends_on 'lzo'

  def install
    system "chmod +x ./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make install"
  end
end
