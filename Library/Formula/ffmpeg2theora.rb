class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  revision 1

  stable do
    url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
    sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"

    depends_on "libkate" => :optional
  end

  bottle do
    cellar :any
    sha256 "a5083a14925664a830e8af88404e4668e5e48546c8ca283f5494fe26dca76f86" => :el_capitan
    sha256 "1d40350a4a67d4ac2da6c55c67d45adee2ca537e1ecd1ccbb59d0c22968fca79" => :yosemite
    sha256 "8e750ddb6435e83d99f6b77ed4736743f361ade2a89efd11868e67b18c114ece" => :mavericks
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
