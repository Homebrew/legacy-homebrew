require 'formula'

class Quvi <Formula
  url 'http://quvi.googlecode.com/files/quvi-0.2.1.tar.bz2'
  sha1 'e7515fa8968f6867034c9ef43e9dd8bb6fd5efea'
  homepage 'http://code.google.com/p/quvi/'

  depends_on 'pkg-config'
  depends_on 'pcre'
  depends_on 'lua'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-smut",
                          "--enable-broken"
    system "make install"
  end
end
