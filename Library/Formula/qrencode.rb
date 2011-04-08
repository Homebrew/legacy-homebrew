require 'formula'

class Qrencode < Formula
  url 'http://megaui.net/fukuchi/works/qrencode/qrencode-3.1.1.tar.gz'
  homepage 'http://megaui.net/fukuchi/works/qrencode/index.en.html'
  md5 'd97f67cbefaf577e6c15923f3cc57b6a'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # For libpng
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make install"
  end
end
