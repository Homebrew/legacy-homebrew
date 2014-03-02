require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.18/libpng-1.5.18.tar.bz2'
  sha1 '52fee0139ff96c98a6a0ef6375845ca366a33c94'

  bottle do
    cellar :any
    sha1 "405736a4cd656764b5bea9ec0b11efb2daddaac0" => :mavericks
    sha1 "ff19f63cc4e5225f199adb981e0e1d54dede4d2b" => :mountain_lion
    sha1 "48f94cb7f6a1417f506cc552fd990e7bd2684dec" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
