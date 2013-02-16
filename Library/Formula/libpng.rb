require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng16/1.6.0/libpng-1.6.0.tar.gz'
  sha1 'ae6ca3f8206a1cdcaf9fb08ae7c0e5ed9e3fa056'

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
