class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.3.1.tar.bz2"
  sha256 "eaf01afbeac02e6a2023fd05be81042eee94b30abd82667f2220b06955f52ab9"

  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    cellar :any
    sha256 "e82e85475795c700ad560280d551c94eac4a7e376eac2848d214e46747023644" => :el_capitan
    sha256 "ce6d4b85c76698e1dd16325d3e4fc0b560a53e5e7a9608aa9060833f7059ff5d" => :yosemite
    sha256 "7844d826d96940c932d89af353e456b17df5cd6ee67627aa51f264d1b713456e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libmpd"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    ENV["CONFIG"] = etc

    ENV.j1
    system "make"
    # Just install ourselves
    bin.install "mpdas"
    man1.install "mpdas.1"
  end

  def caveats
    "Read #{prefix}/README on how to configure mpdas."
  end
end
