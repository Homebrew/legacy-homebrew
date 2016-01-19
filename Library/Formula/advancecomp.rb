class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v1.20/advancecomp-1.20.tar.gz"
  sha256 "590a447cfc7ab3a37ec707e13967a0046a81a888c561ebaff5415b1e946da67b"

  bottle do
    cellar :any
    sha256 "1747345df07102d0e67b8b09d1e56b242632ca7ff2fb6262b6e4ffca47a4b9ce" => :yosemite
    sha256 "415ec861aa810f33b2bf37fdbb3f3e3d30c86b785707874dbbdd7e238bdfeaee" => :mavericks
    sha256 "1f5eda1efb7d5ee16523d03548376cade99aace349895cc45dac3d74017de6c6" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end
