class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.1.tar.gz"
  sha256 "5a24f62a610249d744cbd8d28ee399d8905db7222bf3bdbc8a8b4a76e597695f"
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    revision 2
    sha256 "6a884dc5896176eef15077d74fb5760e0c39f3e24a5f7e13ea617816e313bfec" => :el_capitan
    sha256 "945ee94d193f74d9c8b67be4d7734906dbd66543e4edd1cb99a28e5b76e09d78" => :yosemite
    sha256 "56890809d4c888787beb4fb050153a8bd422d82b4f600b9a8ac92a46fe666e99" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg2" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libmodplug" => :optional
  depends_on "libvorbis" => :optional

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    ENV["SMPEG_CONFIG"] = "#{Formula["smpeg2"].bin}/smpeg2-config" if build.with? "smpeg2"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--enable-music-mod-mikmod" if build.with? "libmikmod"
    args << "--enable-music-mod-modplug" if build.with? "libmodplug"

    system "./configure", *args
    system "make", "install"
  end
end
