class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"

  stable do
    url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
    sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"

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
    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
      "APPEND_LINKFLAGS=-headerpad_max_install_names",
    ]
    scons "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
