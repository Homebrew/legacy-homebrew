class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://advancemame.sourceforge.net/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v1.20/advancecomp-1.20.tar.gz"
  sha256 "590a447cfc7ab3a37ec707e13967a0046a81a888c561ebaff5415b1e946da67b"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end
