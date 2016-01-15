class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-1.1.2.tar.gz"
  sha256 "0e290078e31211baa7b5886bcc8ab6bc048b9fc83882532da4a1a45e58e907fd"

  bottle do
    cellar :any
    sha256 "41f6ff91b8b9b318a366fc692fdbdf768bc92ef61c37fa494f1dffc4babee21f" => :el_capitan
    sha256 "e347b0546ee09d1782e60c99d9e946ee81c6c4fb91c1e067e62585bfddbc04d6" => :yosemite
    sha256 "42bcd3d6fa7500e1c6e58a2d6d8a520d068ab5e2d7264b0ddf909b8302930d0f" => :mavericks
  end

  option "with-custom-modes", "Enable custom-modes for opus see http://www.opus-codec.org/docs/html_api-1.1.0/group__opus__custom.html"

  head do
    url "https://git.xiph.org/opus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
