require 'formula'

class Hunspell < Formula
  url 'http://downloads.sourceforge.net/hunspell/hunspell-1.3.2.tar.gz'
  homepage 'http://hunspell.sourceforge.net/'
  sha1 '902c76d2b55a22610e2227abc4fd26cbe606a51c'

  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui", "--with-readline"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
