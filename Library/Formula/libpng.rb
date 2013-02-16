require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sourceforge.net/project/libpng/libpng15/1.5.14/libpng-1.5.14.tar.gz'
  sha1 '67f20d69564a4a50204cb924deab029f11ad2d3c'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    sha1 '382eb757c38a4c326410a42deab8b4a8c22a6c13' => :mountainlion
    sha1 'deb8a3143e61d0d1123781974d23a89e10ede779' => :lion
    sha1 '4a72aa9046feecec944de5063834f2613289db5c' => :snowleopard
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
