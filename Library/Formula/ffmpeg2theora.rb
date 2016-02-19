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
    sha256 "a36254df54c3de32283defd45659985edcc27dc20f21a5c867d4b188b1fd9a12" => :el_capitan
    sha256 "7240f49471e1cc6b76d4c947826302eab338431a3fefbbfdc9ccdd00fe95b99e" => :yosemite
    sha256 "a5d8069a8307d480554e72c76ecb390ab37544d75ab3d9116854df8c4276a100" => :mavericks
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
