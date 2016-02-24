class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "http://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v1.20/advancecomp-1.20.tar.gz"
  sha256 "590a447cfc7ab3a37ec707e13967a0046a81a888c561ebaff5415b1e946da67b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b920a8b98b6b79b0531d03b72180e6dde7664da504f4943bcb237703347de1bd" => :el_capitan
    sha256 "4c53c032983006823c7e119fd3f7516a9a9321bdd9d165a7ef0abaabc5b669cb" => :yosemite
    sha256 "119316cdf32ce8129a09e786a31bd6c21d3b153eadd6cd55e098f78b6f1ed884" => :mavericks
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
