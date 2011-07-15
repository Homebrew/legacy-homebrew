require 'formula'

class CenterIm < Formula
  url 'http://www.centerim.org/download/releases/centerim-4.22.10.tar.gz'
  homepage 'http://www.centerim.org/index.php/Main_Page'
  md5 '7565c3c8cac98a4e2d8524076a44676f'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'jpeg' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
