class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "http://www.50hz.ws/mpdas/"
  url "http://www.50hz.ws/mpdas/mpdas-0.3.1.tar.bz2"
  sha256 "eaf01afbeac02e6a2023fd05be81042eee94b30abd82667f2220b06955f52ab9"

  head "https://github.com/hrkfdn/mpdas.git"

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
