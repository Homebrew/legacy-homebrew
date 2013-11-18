require 'formula'

class Lensfun < Formula
  homepage 'http://lensfun.berlios.de'
  url 'http://sourceforge.net/projects/lensfun.berlios/files/lensfun-0.2.8.tar.bz2/download'
  head 'svn://svn.berlios.de/lensfun/trunk'
  sha256 'f88f97fbc78259a2b2edddef295caf50770901107c8469e54bb5e9699faa1a48'

  depends_on 'cmake' => :build
  depends_on 'doxygen' => :optional
  depends_on 'glib'
  depends_on 'libpng'
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
