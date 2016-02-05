class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitweb.torproject.org/torsocks.git/"
  url "https://git.torproject.org/torsocks.git",
    :tag => "v2.1.0",
    :revision => "a43a3656a5bb4391fb1654d5ff44a5257e1f165f"

  head "https://git.torproject.org/torsocks.git"

  bottle do
    sha256 "9bac7fb47e4b5525975ae4f2a70410dbd94941c7b058d3177fcc07fad0aecd87" => :el_capitan
    sha256 "eefc247e6b21f0cf8f5e77fff478dc541e1e41cc292c5b955ec12265073375ab" => :yosemite
    sha256 "d58029eed52863a5b7f024f0942bf02d17e5da248be3d59ccd75d9380be22f2d" => :mavericks
    sha256 "28f2bdf7f4e5c0fccda688dfbd259addffefa7726dddd703db56bd4769d6b321" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/torsocks", "--help"
  end
end
