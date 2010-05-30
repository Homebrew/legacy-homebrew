require 'formula'

class Cairo <Formula
  url 'http://cairographics.org/releases/cairo-1.8.10.tar.gz'
  homepage 'http://cairographics.org/'
  md5 'b60a82f405f9400bbfdcf850b1728d25'

  depends_on 'pkg-config'
  depends_on 'libpng'
  depends_on 'pixman'

  # Comes with Snow Leopard, but not Leopard
  def keg_only?
    :provided_by_osx
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x"
    system "make install"
  end
end
