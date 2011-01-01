require 'formula'

class Cairo <Formula
  url 'http://cairographics.org/releases/cairo-1.10.2.tar.gz'
  homepage 'http://cairographics.org/'
  md5 'f101a9e88b783337b20b2e26dfd26d5f'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'pixman'

  # Comes with Snow Leopard, but not Leopard
  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x"
    system "make install"
  end
end
