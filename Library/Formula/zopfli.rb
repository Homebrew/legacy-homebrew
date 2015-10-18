class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://code.google.com/p/zopfli/"
  url "https://zopfli.googlecode.com/files/zopfli-1.0.0.zip"
  sha256 "e20d73b56620285e6cce5b510d8e5da6835a81940e48cdf35a69090e666f3adb"
  head "https://code.google.com/p/zopfli/", :using => :git

  def install
    # Makefile hardcodes gcc
    inreplace "makefile", "gcc", ENV.cc
    system "make", "-f", "makefile"
    bin.install "zopfli"
    if build.head?
      system "make", "-f", "makefile", "zopflipng"
      bin.install "zopflipng"
    end
  end

  test do
    system "#{bin}/zopfli"
  end
end
