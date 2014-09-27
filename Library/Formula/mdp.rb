require "formula"

class Mdp < Formula
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/0.91.3.tar.gz"
  sha1 "e8a0264068c21df1f00e391ec22e674141fddcc1"

  def install
    system "make"
    system "make", "install", "DESTDIR=#{bin}"
    share.install "sample.md"
  end

  test do
    # Go through two slides and quit.
    ENV["TERM"] = "xterm"
    system "echo jjq | #{bin}/mdp #{share}/sample.md"
  end
end
