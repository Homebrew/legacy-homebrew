class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.5.2-src.tar.bz2"
  sha256 "5b064596305c6f765a753e96e08224dd71b31c20b72bdaf0f205da16b76a347d"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "03de0ad0f4a6c20b7661af67dd2784e988b7f21a0c54fa37e06eb5a56772a782" => :el_capitan
    sha256 "f9d360a9cb4eeda05f17c9aee7f11f336e3415e7607203af3c66502a588bbc36" => :yosemite
    sha256 "2a2735a1773b27297b72bcd278cdbfc8d0aa895976b26c48026379f952ed63e6" => :mavericks
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
