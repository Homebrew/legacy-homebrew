require "formula"

class Sptk < Formula
  homepage "http://sp-tk.sourceforge.net/"
  url "https://downloads.sourceforge.net/sp-tk/SPTK-3.7.tar.gz"
  sha1 "319b8850f4ea4a294311fbb53f2421088c7e5171"

  depends_on :x11

  conflicts_with "libextractor", :because => "both install `extract`"

  fails_with :gcc do
    cause "Segmentation fault during linking."
  end

  fails_with :llvm do
    cause "Segmentation fault during linking."
  end

  def install
    system "./configure", "CC=#{ENV.cc}", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/impulse", "-h"
    system "#{bin}/impulse -n 10 -l 100 | hexdump"
  end
end
