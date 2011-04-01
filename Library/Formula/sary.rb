require 'formula'

class Sary < Formula
  url 'http://sary.sourceforge.net/sary-1.2.0.tar.gz'
  md5 '10b9a803025c5f428014a7f1ff849ecc'
  homepage 'http://sary.sourceforge.net/'
  version '1.2.0'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
