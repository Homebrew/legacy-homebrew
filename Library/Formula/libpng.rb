require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.14/libpng-1.5.14.tar.gz'
  sha1 '67f20d69564a4a50204cb924deab029f11ad2d3c'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    sha1 '5e7feb640d654df0c2ac072d86e46ce9df9eaeee' => :mountain_lion
    sha1 'bbd94d671653943cf21314911978d90f5fb536df' => :lion
    sha1 'fb685cfb8b37b883bf004ee7c9ca785d3435b155' => :snow_leopard
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
