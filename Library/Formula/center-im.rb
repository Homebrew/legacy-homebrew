require 'formula'

class CenterIm < Formula
  url 'http://www.centerim.org/download/releases/centerim-4.22.9.tar.gz'
  homepage 'http://www.centerim.org/index.php/Main_Page'
  md5 'c43911508205e0277529230c8316a298'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'jpeg' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
