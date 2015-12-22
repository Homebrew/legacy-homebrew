class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "http://cms.ferzkopp.net/index.php/software/13-sdl-gfx"
  url "http://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.1.tar.gz"
  sha256 "d69bcbceb811b4e5712fbad3ede737166327f44b727f1388c32581dbbe8c599a"

  bottle do
    cellar :any
    sha256 "bee90056a343bd99bbd437b8ccf22ae112780602f533c3de23c384ac86063977" => :el_capitan
    sha256 "a3dc0c6eb41221f71781038f6705c36761c9489947eb418adc013e7a6ab00045" => :yosemite
    sha256 "e7888e8bbdbda56ec2941b53a74482d1d74c3e321b632af1099d909d209497cd" => :mavericks
  end

  option :universal

  depends_on "sdl2"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
