require 'formula'

class Cairo <Formula
  url 'http://cairographics.org/releases/cairo-1.10.0.tar.gz'
  homepage 'http://cairographics.org/'
  md5 '70a2ece66cf473d976e2db0f75bf199e'

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
