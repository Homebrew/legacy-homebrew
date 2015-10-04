class Ispell < Formula
  desc "International Ispell"
  homepage "http://lasr.cs.ucla.edu/geoff/ispell.html"
  url "http://www.cs.hmc.edu/~geoff/tars/ispell-3.4.00.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/ispell/ispell_3.4.00.orig.tar.gz"
  sha256 "5dc42e458635f218032d3ae929528e5587b1e7247564f0e9f9d77d5ccab7aec2"

  bottle do
    sha256 "81d9f6f9aca0f92ba3bece2ad22d0b0bca29c719304c6c5e8e59b02a3c8763da" => :el_capitan
    sha256 "ff46baf7aa6daf42fddde68897bd80dbb073922b4556c502e7b0072656b48498" => :yosemite
    sha256 "f1ee90dcc76682d17c2b758d2a896493448753acc0e556e9b0c8bf7ec0f552df" => :mavericks
    sha256 "dbbaabbc715f6f16dfb9f2cd05755a88e471b92c63d7f87f79a940a5df8dadfb" => :mountain_lion
  end

  def install
    ENV.deparallelize
    ENV.no_optimization

    # No configure script, so do this all manually
    cp "local.h.macos", "local.h"
    chmod 0644, "local.h"
    inreplace "local.h" do |s|
      s.gsub! "/usr/local", prefix
      s.gsub! "/man/man", "/share/man/man"
      s.gsub! "/lib", "/lib/ispell"
    end

    chmod 0644, "correct.c"
    inreplace "correct.c", "getline", "getline_ispell"

    system "make config.sh"
    chmod 0644, "config.sh"
    inreplace "config.sh", "/usr/share/dict", "#{share}/dict"

    (lib/"ispell").mkpath
    system "make", "install"
  end

  test do
    assert_equal "BOTHER BOTHE/R BOTH/R",
                 `echo BOTHER | #{bin}/ispell -c`.chomp
  end
end
