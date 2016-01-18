class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-1.1.2.tar.gz"
  sha256 "0e290078e31211baa7b5886bcc8ab6bc048b9fc83882532da4a1a45e58e907fd"

  bottle do
    cellar :any
    sha256 "bf658ab20eb10724c16b619eaac1c10f1f746e7656b03be5ae1ef408178f405b" => :el_capitan
    sha256 "252c20e9dfcfee3b628cf4344bb3586b5adf83d5772b493b853f0968e5ebf698" => :yosemite
    sha256 "8a43607dcf83bc516b823893d3c7f80d2ec9a5a2a7802d314f026858360c9303" => :mavericks
  end

  option "with-custom-modes", "Enable custom-modes for opus see https://www.opus-codec.org/docs/opus_api-1.1.2/group__opus__custom.html"

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
