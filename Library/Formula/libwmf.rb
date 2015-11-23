class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "http://wvware.sourceforge.net/libwmf.html"
  url "https://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz"
  sha256 "5b345c69220545d003ad52bfd035d5d6f4f075e65204114a9e875e84895a7cf8"
  revision 1

  bottle do
    revision 1
    sha256 "a062ace9cbca36cd99122a6389b80a431326de7ef362dc860c74b500ed35e64c" => :el_capitan
    sha1 "47baf7411f61408bd715f3f0570531080b3d8665" => :yosemite
    sha1 "d195e1c4297a0563a021a76a5e1ee61dd2b1be4d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}"
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make", "install"
  end
end
