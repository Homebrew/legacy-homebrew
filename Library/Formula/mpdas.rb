require "formula"

class Mpdas < Formula
  homepage "http://www.50hz.ws/mpdas/"
  url "http://www.50hz.ws/mpdas/mpdas-0.3.1.tar.bz2"
  sha1 "c9aaf18243b3ae59264ba862f6fb94dfed55dbda"

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
