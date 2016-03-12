class Wordwarvi < Formula
  desc "Word War vi is an old school shooter with an \"Emacs vs. vi\" theme."
  homepage "https://smcameron.github.io/wordwarvi/"
  url "https://github.com/smcameron/wordwarvi/archive/v1.0.2.tar.gz"
  sha256 "361d15af6edbe6db032db24de54e8f489a05b230572a8793b9889e2b8308a7ad"

  depends_on "pkg-config" => :build

  depends_on "gtk+"
  depends_on "pango"
  depends_on "glib"
  depends_on "cairo"
  depends_on "pixman"     => :build
  depends_on "fontconfig" => :build
  depends_on "freetype"   => :build
  depends_on "libpng"     => :build
  depends_on "harfbuzz"   => :build
  depends_on "gdk-pixbuf"
  depends_on "atk"

  depends_on "portaudio"
  depends_on "libvorbis"

  def install
    system "make", "PREFIX=#{prefix}", "install"
    bin.install "#{prefix}/games/wordwarvi"
  end

  test do
    system "#{bin}/wordwarvi", "--version"
  end
end
