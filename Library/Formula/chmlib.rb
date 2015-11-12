class Chmlib < Formula
  desc "Library for dealing with Microsoft ITSS/CHM files"
  homepage "http://www.jedrea.com/chmlib"
  url "http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/chmlib/chmlib_0.40.orig.tar.gz"
  sha256 "512148ed1ca86dea051ebcf62e6debbb00edfdd9720cde28f6ed98071d3a9617"

  bottle do
    cellar :any
    revision 2
    sha256 "6b834a6ae6e95f8daaa726fd6ae1a2d3e60335f98862fea9e790c24e5a6411d1" => :el_capitan
    sha256 "bdc19058cbf1690e960bd88d06f6c8b2ff47f8b743947eb82c259ba394881a65" => :yosemite
    sha256 "366c564a2cd0185d84ff6892f5d773f80ddee50f6db39e763060b3ebb31413b3" => :mavericks
    sha256 "a62f8bdc1ffa2dc6084a61c78a1027c2215e0a2986ffeae755701769c667b3a8" => :mountain_lion
  end

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make", "install"
  end
end
