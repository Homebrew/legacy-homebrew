require "formula"

class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/1.5.3.tar.gz"
  sha1 "7f2fcf458badf42c5401587b7be19a4f5c5b439c"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system "finatra"
  end
end
