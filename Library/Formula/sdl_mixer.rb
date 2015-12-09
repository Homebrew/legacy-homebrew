class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"

  bottle do
    cellar :any
    revision 1
    sha256 "51556b8d0036664453d71bd52cce26bf25a246b15f88f887d08e658f9b62d2e5" => :el_capitan
    sha256 "80e6127e15c1613bad625841cad39c1df3935d332b6c38a8ded1f022e38b3850" => :yosemite
    sha256 "5fc9bb3ce927e706e413b9171a7a312f0d22e663f8cd362012fc8cdb66c20c25" => :mavericks
    sha256 "bb94a051a4426e1014c6a5005a225ad87722fc57f3f44effa8bc602b67c9cf8e" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libvorbis" => :optional

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
