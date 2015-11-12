class Dvorak7min < Formula
  desc "Dvorak (simplified keyboard layout) typing tutor"
  homepage "http://dvorak7min.sourcearchive.com/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  version "1.6.1"
  sha256 "4cdef8e4c8c74c28dacd185d1062bfa752a58447772627aded9ac0c87a3b8797"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d4bf1a053028f0712193e33911c2af3fb4f0a71b37480969b5c03b798d4930ae" => :el_capitan
    sha256 "42cad6dbf3f41053e5ba7509657dcf7e02c6211412efb246eaaa9de853a09d35" => :yosemite
    sha256 "096700b282a6130a3948e3fc8535584cea129865aaaef81f5d89fac3a39d61c1" => :mavericks
  end

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
