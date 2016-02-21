class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "http://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.0.0.tar.gz"
  sha256 "34f0cb60eb2e7400e9964de5ee439851b3e51a942206cccc2961fd41b42ee5d2"
  revision 1

  bottle do
    sha256 "a680addede577230dbf5c3d342f6efef2fa15186e844f85855345a7a8687b60f" => :el_capitan
    sha256 "0fc1277ee00d45ec3bcf75fb7626c9ab87cd5b0cbb188f9601a0b0921f484611" => :yosemite
    sha256 "c9629d72b8b595ac76346a776f4046c99d93d4db361eda6dac5998f9cabbb585" => :mavericks
  end

  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sox"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-gtk"]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
