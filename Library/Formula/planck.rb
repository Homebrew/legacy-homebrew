class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  head "https://github.com/mfikes/planck.git"
  url "https://github.com/mfikes/planck/archive/1.6.tar.gz"
  sha256 "e734a5ccbed1b63273c06555cf61acb6f95a3b18433ba0e8ffdeadba176ccbe6"

  bottle do
    cellar :any
    sha256 "403a8300b584bd78ddf2db45da9c50dda359f08d1b8d84962ff43f0712bae76a" => :yosemite
    sha256 "7c6aaed8b00064196c1a78d313c9c52fdded7b4eb118733fd94d396d3bac818e" => :mavericks
    sha256 "afe3b52af788df04ac564d5d315d442433ce7c360d14c72aaddfc2364cca4b78" => :mountain_lion
  end

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :mountain_lion

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
