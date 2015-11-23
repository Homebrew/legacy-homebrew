class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
  sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"

  bottle do
    cellar :any
    sha256 "9b44c60636c37d24d3344283b79f8ce292efedb035d00269f8afc0b1ba65f7c3" => :yosemite
    sha256 "e05e8e051e8dd043001714a4c95d2ef5ebbe1f0abe9d7a4e89ab9eb95ec475a9" => :mavericks
    sha256 "ab8a1acb87b1b626ef287684b8e2a32d265ca9e70abb9443d3163cf865cdde0f" => :mountain_lion
  end

  head do
    url "https://hg.icculus.org/icculus/SDL_sound", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "speex" => :optional
  depends_on "physfs" => :optional

  def install
    ENV.universal_binary if build.universal?

    if build.head?
      inreplace "bootstrap", "/usr/bin/glibtoolize", "#{Formula["libtool"].opt_bin}/glibtoolize"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
