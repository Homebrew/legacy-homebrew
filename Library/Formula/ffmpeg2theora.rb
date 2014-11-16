require "formula"

class Ffmpeg2theora < Formula
  homepage "http://v2v.cc/~j/ffmpeg2theora/"
  revision 1

  stable do
    url "http://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.29.tar.bz2"
    sha1 "7e78c5ddb8740b33a6ae4c9da76047bd8e662791"

    # Fixes build with ffmpeg 2.x by removing use of deprecated constant
    patch do
      url "http://git.xiph.org/?p=ffmpeg2theora.git;a=patch;h=d3435a6a83dc656379de9e6523ecf8d565da6ca6"
      sha1 "5a3e48c386ac077ab58afa6c49631c88f8f85929"
    end

    depends_on "libkate" => :optional
  end

  bottle do
    cellar :any
    revision 1
    sha1 "94fc80f71d14abe75e467c8d631e67ee51dbd685" => :yosemite
    sha1 "acf1a399ee26ae9b9303b649b1e405881da1664c" => :mavericks
    sha1 "7c215c1078da702b774e8f99787f9bd87975aedc" => :mountain_lion
  end

  head do
    url "git://git.xiph.org/ffmpeg2theora.git"

    depends_on "libkate" => :recommended
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  def install
    args = ["prefix=#{prefix}", "mandir=PREFIX/share/man"]
    scons "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
