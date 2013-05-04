require 'formula'

class CenterIm < Formula
  homepage 'http://www.centerim.org/index.php/Main_Page'
  url 'http://www.centerim.org/download/releases/centerim-4.22.10.tar.gz'
  sha1 '46fbac7a55f33b0d4f42568cca21ed83770650e5'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'jpeg' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
