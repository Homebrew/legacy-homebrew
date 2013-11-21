require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/older-releases/1.5.14/libpng-1.5.14.tar.gz'
  sha1 '67f20d69564a4a50204cb924deab029f11ad2d3c'

  bottle do
    revision 1
    sha1 '73625454f0982d11e88165fbcdcd58045a103250' => :mavericks
    sha1 'dc3e64a3357d59c09ac517b83e048525f0a9c9ae' => :mountain_lion
    sha1 'c3d9bca7dc5a6136b5ab19dc3635b194ae4186b1' => :lion
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
