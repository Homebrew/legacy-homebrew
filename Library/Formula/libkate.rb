class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://code.google.com/p/libkate/"
  url "https://libkate.googlecode.com/files/libkate-0.4.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libk/libkate/libkate_0.4.1.orig.tar.gz"
  sha256 "c40e81d5866c3d4bf744e76ce0068d8f388f0e25f7e258ce0c8e76d7adc87b68"
  revision 1

  bottle do
    revision 2
    sha1 "fd0287aca68b310e7c9d856c352b7453de2042c3" => :yosemite
    sha1 "3cdb628edf85be70d407a15070a3c9bc10b83215" => :mavericks
    sha1 "f47ba4978a5b1ff7a3aa7e9a6590e5d799cc2226" => :mountain_lion
  end

  option "with-docs", "Build documentation"
  option "with-examples", "Build example streams"

  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "oggz" if build.with? "examples"
  depends_on "libpng"
  depends_on "libogg"
  depends_on "wxmac" => :optional

  fails_with :gcc do
    build 5666
    cause "Segfault during compilation"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/katedec", "-V"
  end
end
