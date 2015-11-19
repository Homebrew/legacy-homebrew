class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz"
  sha256 "b9727015a58affcf3db527322bf8c4d2fcf39f5f6b8f15dbceca20206cbe1d95"

  bottle do
    cellar :any
    sha256 "c6bd7005b94ea672d5f78ea295ea53e8a2c46d1dfb10b7c3ae4a396ea34939f6" => :el_capitan
    sha256 "3f4b7f577aa33eedac368a0fbc1d7fccb28db451365a27164e950990efaf72b6" => :yosemite
    sha256 "39340732d092ce7e29dcda519f6bb4185f3760bbb111f7f0f6bc912030114b0c" => :mavericks
    sha256 "f1e5202d8e95f14adddf952f78b2a0e56e6b0a14abdf7b32a1baf34eb513bc44" => :mountain_lion
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
