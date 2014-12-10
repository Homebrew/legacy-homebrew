require "formula"

class Finatra < Formula
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/1.5.3.tar.gz"
  sha1 "bb9fe6a7175c1bff404f515731f071e9f8cca586"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system "finatra"
  end
end
