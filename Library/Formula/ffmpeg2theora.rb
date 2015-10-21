class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  revision 1

  stable do
    url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.29.tar.bz2"
    sha256 "214110e2a5afdd8ff8e0be18152e893dbff5dabc1ae1d1124e64d9f93eae946d"

    # Fixes build with ffmpeg 2.x by removing use of deprecated constant
    patch do
      url "https://git.xiph.org/?p=ffmpeg2theora.git;a=commitdiff_plain;h=d3435a6a83dc656379de9e6523ecf8d565da6ca6"
      sha256 "0655ed219b438d1eefd8ad31fad3c1b8da77f13b911eb6247466ac46ce060f3c"
    end

    depends_on "libkate" => :optional
  end

  bottle do
    cellar :any
    revision 3
    sha256 "2f53a6eee671251c96d62f4e73b8aecf4d5fc6abc6379633031edc8d6fe1b46c" => :el_capitan
    sha256 "1144caff1384628e84aafe3c90d74cb08d90bb1f98b2e1cfe0a2eecdebbc5692" => :yosemite
    sha256 "f5da61547028805ff495616a97328832a21ea798aaa9eb9363e220ed9fa2ef4d" => :mavericks
  end

  head do
    url "https://git.xiph.org/ffmpeg2theora.git"

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
