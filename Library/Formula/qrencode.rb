require 'formula'

class Qrencode < Formula
  homepage 'http://fukuchi.org/works/qrencode/index.html.en'
  url 'http://fukuchi.org/works/qrencode/qrencode-3.4.3.tar.bz2'
  sha1 'a5056cf2fdc699ecf1d3c0cbea7b50993b0bf54e'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libpng'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
