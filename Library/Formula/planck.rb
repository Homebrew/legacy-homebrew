class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  head "https://github.com/mfikes/planck.git"
  url "https://github.com/mfikes/planck/archive/1.7.tar.gz"
  sha256 "11f5017519c3a10267465c73ef9da7c1f3c228cebed056b0ce7a8335e141aefc"

  bottle do
    cellar :any
    sha256 "403a8300b584bd78ddf2db45da9c50dda359f08d1b8d84962ff43f0712bae76a" => :yosemite
    sha256 "7c6aaed8b00064196c1a78d313c9c52fdded7b4eb118733fd94d396d3bac818e" => :mavericks
    sha256 "afe3b52af788df04ac564d5d315d442433ce7c360d14c72aaddfc2364cca4b78" => :mountain_lion
  end

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :lion

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
