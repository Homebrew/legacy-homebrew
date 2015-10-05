class Opus < Formula
  desc "Audio codec"
  homepage "http://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz"
  sha256 "b9727015a58affcf3db527322bf8c4d2fcf39f5f6b8f15dbceca20206cbe1d95"

  bottle do
    cellar :any
    sha256 "c6bd7005b94ea672d5f78ea295ea53e8a2c46d1dfb10b7c3ae4a396ea34939f6" => :el_capitan
    sha1 "5fb89890cfc8c254a6f13f9657a66da385887b2b" => :yosemite
    sha1 "8ac2e93276b0df2f69c01d0b727fbff57a637e9e" => :mavericks
    sha1 "a7e6ed2455861c41e021fec280b6fa28462341a2" => :mountain_lion
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
