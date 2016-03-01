class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.6.0-src.tar.gz"
  sha256 "79e0b2f08260fb3f0fc131c1ac17e26d9e207b36fbd3734f980957457b8492a7"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "72c9b1340402476453463844617ceccbd8961d055a31a0c34e55e88d035c1fc2" => :el_capitan
    sha256 "1a389dba5a828609571acb3ca71332ef0363ea07bde8b82ed87a30d7c77ac9c6" => :yosemite
    sha256 "d6b5ef4c1593ad620e1a3cc3d7fb2f082e6e763883a36b353e4d068881cea9a4" => :mavericks
  end

  option "with-openmp", "Enable OpenMP"

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "little-cms2" => :optional

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
