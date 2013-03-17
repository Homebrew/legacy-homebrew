require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.14/libpng-1.5.14.tar.gz'
  sha1 '67f20d69564a4a50204cb924deab029f11ad2d3c'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    sha1 '' => :mountain_lion
    sha1 '' => :lion
    sha1 '' => :snow_leopard
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
