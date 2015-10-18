class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz"
  sha256 "a8ce0e161793791adeff258ca6214267fdd41b3c073d2581cd5265c8646f725b"

  bottle do
    cellar :any
    sha256 "96cb856887d20982443ac02647e20cec3df1496bca263b3b1f733c3e125bd064" => :yosemite
    sha256 "5a9fadfc66d69b7c2665029ea957d1b1d1b1a3381f932be8ab74c1e2c344370e" => :mavericks
    sha256 "b66197fe45e0a83fb658c94c95c5d755ace4fef16fb1d5c94f3b0f68876e0afc" => :mountain_lion
  end

  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg2" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libvorbis" => :optional

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    ENV["SMPEG_CONFIG"] = "#{Formula["smpeg2"].bin}/smpeg2-config" if build.with? "smpeg2"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
