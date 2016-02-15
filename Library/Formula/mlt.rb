class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "http://www.mltframework.org/"
  url "https://downloads.sourceforge.net/mlt/mlt/mlt-0.9.6.tar.gz"
  sha256 "ab999992828a03dadbf62f6a131aada776cfd7afe63a94d994877fdba31a3000"

  bottle do
    sha256 "46779015d1ce48aa85d887da98e0144cd7b9a43b8166dc587c2b91aad89b52d0" => :yosemite
    sha256 "54f23f9e8dcfc8ad7f357cd25f0c9855fb6a8ee3a92e6db7a0e390733f79022f" => :mavericks
    sha256 "3d7bed128cd7a5e98d014e2afaf69ad7f4232d961293cf3cc57e4c0040a8ff80" => :mountain_lion
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
