require "formula"

class Mdp < Formula
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/0.92.2.tar.gz"
  sha1 "d01db33bb3ce1206c48e0c191adb14746f3fcdd5"

  bottle do
    cellar :any
    sha1 "97df5121df0867e67d045f38111ec13ec43f6f83" => :yosemite
    sha1 "189097b46a0d97e68cf86e7ff6243a6aa79cde2c" => :mavericks
    sha1 "d38a3bd49fda2d6b8d41362057f57eec8b091511" => :mountain_lion
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
