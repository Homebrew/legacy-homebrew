require 'formula'

class Quvi <Formula
  url 'http://quvi.googlecode.com/files/quvi-0.2.0.tar.bz2'
  homepage 'http://code.google.com/p/quvi/'
  md5 '3f5c4060d147d2825634e5ea5c19a4e5'

  depends_on 'pkg-config'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-smut",
                          "--enable-broken"
    system "make install"
  end
end
