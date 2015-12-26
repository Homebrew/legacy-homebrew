class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz"
  sha256 "a8ce0e161793791adeff258ca6214267fdd41b3c073d2581cd5265c8646f725b"
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    revision 1
    sha256 "f32a78d1b3c6d95368124407b099215d6d778fa11f0acff68d4cf1f76f7574a0" => :el_capitan
    sha256 "c4ee54f586e9f88bf29393274ec3811426068484f03d0e48500a07217b5d69c8" => :yosemite
    sha256 "7b127a9c1aec81587871db9c288e3d17219b76f8bebc486bce91a6c2a845c4c5" => :mavericks
  end

  stable do
    # Next 4 patches are required to build sdl2_mixer 2.0.0 with libmodplug.
    # Fix is already in upstream, see changeset 695 (https://hg.libsdl.org/SDL_mixer/rev/6a5e6d8d6a35).
    patch do
      url "https://hg.libsdl.org/SDL_mixer/raw-diff/6a5e6d8d6a35/configure"
      sha256 "b5b47486dc84725b0b5464997111b5b5fad5fa97c5ca8b22a7dac0d89c1452bd"
    end
    patch do
      url "https://hg.libsdl.org/SDL_mixer/raw-diff/6a5e6d8d6a35/configure.in"
      sha256 "be60dace4d169afcf40a0c9974a09a2d4f1976cc94f37d7b40e4ffc3a2cb77e7"
    end
    patch do
      url "https://hg.libsdl.org/SDL_mixer/raw-diff/6a5e6d8d6a35/dynamic_modplug.h"
      sha256 "cb0c1251d7f018aa8a98c8f7b3dc9553bb22629ca32f2c89235e61daeda42fe2"
    end
    patch do
      url "https://hg.libsdl.org/SDL_mixer/raw-diff/6a5e6d8d6a35/music_modplug.h"
      sha256 "c6318a877effd5b5186ca49dbd040ecb1cfd39e73d03a380c80331fb86bfc00d"
    end
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
