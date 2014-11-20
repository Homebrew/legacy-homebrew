require "formula"

class Clamp < Formula
  homepage "http://jide.github.io/clamp"
  url "https://github.com/jide/clamp.git", :tag => "1.3.1"
  sha1 "32876334efce5493aeaf9e76c346b8e7d9266922"

  depends_on "mariadb"

  def install
    inreplace "clamp", /\/usr\/local\/clamp/, prefix
    prefix.install Dir["*"]
    bin.install_symlink '../clamp'
  end

  test do
    system bin/"clamp", "help"
  end
end
