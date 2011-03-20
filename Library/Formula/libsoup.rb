require 'formula'

class Libsoup <Formula
  url 'http://ftp.acc.umu.se/pub/gnome/sources/libsoup/2.1/libsoup-2.1.13.tar.gz'
  homepage 'http://library.gnome.org/devel/libsoup/stable/'
  md5 '5558c02ab9c9d7b62e6637936b0de580'

  depends_on 'pkg-config'
  depends_on 'gnutls'
  depends_on 'sqlite'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
