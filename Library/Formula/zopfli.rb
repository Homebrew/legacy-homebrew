class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://zopfli.googlecode.com/files/zopfli-1.0.0.zip"
  sha256 "e20d73b56620285e6cce5b510d8e5da6835a81940e48cdf35a69090e666f3adb"
  head "https://github.com/google/zopfli.git"

  def install
    if build.stable?
      # Makefile hardcodes gcc
      inreplace "makefile", "gcc", ENV.cc
      system "make", "-f", "makefile"
    else
      inreplace "Makefile", "gcc", ENV.cc
      inreplace "Makefile", "g++", ENV.cxx
      inreplace "Makefile", "-soname", "-o"
      system "make", "zopfli", "zopflipng", "libzopfli", "libzopflipng"
      bin.install "zopflipng"
      lib.install "libzopfli.so.1" => "libzopfli.dylib"
      lib.install "libzopflipng.so.1" => "libzopflipng.dylib"
      include.install "src/zopfli/"
      include.install "src/zopflipng/"
    end
    bin.install "zopfli"
  end

  test do
    system "#{bin}/zopfli"
  end
end
