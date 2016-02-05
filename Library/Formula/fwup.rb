class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/archive/v0.5.2.tar.gz"
  sha256 "e7735e503f894f19b5a3717c085aa9f6f18702696de91f17bd5405f95f8d6f98"

  bottle do
    cellar :any
    sha256 "62f51e99e6fa6febfa1f1eb713e2e60c9b11c7572b69fb54b0e1442f70db0763" => :el_capitan
    sha256 "c26a38d9ed03cd903839b22d3f86d9f6e23443092d7a75c5f4fd149815d9c8c3" => :yosemite
    sha256 "18972917d65e578a7b2bf2d2a37fb9723e0bc7fce3f90b26f4c5435c50cdce50" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
