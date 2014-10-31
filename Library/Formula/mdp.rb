require "formula"

class Mdp < Formula
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/0.92.2.tar.gz"
  sha1 "d01db33bb3ce1206c48e0c191adb14746f3fcdd5"

  bottle do
    cellar :any
    sha1 "cc6da77fce8cc33d8e563d8069b07eb7de147601" => :mavericks
    sha1 "ea647ad8b94575a91125c0b967c02ab8cdf141b2" => :mountain_lion
    sha1 "7394b1dc8b9aa4e96debb0af0e75dca8828d119c" => :lion
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    share.install "sample.md"
  end

  test do
    # Go through two slides and quit.
    ENV["TERM"] = "xterm"
    system "echo jjq | #{bin}/mdp #{share}/sample.md"
  end
end
