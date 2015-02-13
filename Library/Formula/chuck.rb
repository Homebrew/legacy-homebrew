require "formula"

class Chuck < Formula
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.0.tgz"
  sha1 "a97ad56f9fd1b0793ead099cc9723e888b3782c3"

  bottle do
    cellar :any
    sha1 "54f55280bd5b153277bd7657a8338ae03f674a08" => :yosemite
    sha1 "54a4b27ef78e49544134fbe688a356e4e9001dfc" => :mavericks
    sha1 "515e650f18e765e023947a2f8c75334611f0f7ed" => :mountain_lion
  end

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    (share/"chuck").install "examples"
  end
end
