class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.5.0-src.tar.bz2"
  sha256 "83c941f9fc7d4d6a566ca1243bff38fc9c46e4c74b6dc352fb5eac68b2297839"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "35d5b9ee2b42ba45baa378fed42e69cf2dfb74f04eaf8b7286426a314ab23a4e" => :yosemite
    sha256 "152ba12f6637125935f2f3bbcdfeb0f056f20ada21931859f1507cb6f9ebf417" => :mavericks
    sha256 "39f9bb7d8b6289bfdb8809a3bd48af52a3760ab268e98f1a8fa89078dd4c050e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "little-cms2" => :optional

  option "with-openmp", "Enable OpenMP"
  needs :openmp if build.with? "openmp"

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug

    args = ["--prefix=#{prefix}"]
    args << "--with-lcms2" if build.with? "little-cms2"

    if build.with? "openmp"
      args << "--with-openmp"
      args << "--without-cocoa"
    end

    system "./configure", *args
    system "make", "install", "CC=#{ENV.cc}"

    man1.install "pngquant.1"
    lib.install "lib/libimagequant.a"
    include.install "lib/libimagequant.h"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    File.exist? testpath/"out.png"
  end
end
