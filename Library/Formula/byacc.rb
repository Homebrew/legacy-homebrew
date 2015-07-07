class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "http://invisible-island.net/byacc/byacc.html"
  url "ftp://invisible-island.net/byacc/byacc-20141128.tgz"
  sha1 "59ea0a166b10eaec99edacc4c38fcb006c6e84d3"

  bottle do
    cellar :any
    sha1 "730c5b32d50fc5ebc21f519ac5828d03c50e57ef" => :yosemite
    sha1 "76ef279d3d8466aefa7a921aa2cf663e86486156" => :mavericks
    sha1 "69414e8c76e803da7b0102e6fc4d0096613a0128" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
