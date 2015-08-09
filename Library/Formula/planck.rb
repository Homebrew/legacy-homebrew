class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "https://github.com/mfikes/planck/archive/1.4.tar.gz"
  sha256 "57e4fdfb3dbb80b20aa71baa40ed03fe845a442d2ddd6ba9e942b4993ed13385"

  bottle do
    cellar :any
    revision 1
    sha256 "0030ca55de4f0df65a9bba8bdbd7d338488dfe640d10d31b1419622fc7482f62" => :yosemite
    sha256 "3bf4880b65545fd25f3dc435fbb41772fdf5010b246349cd66262924197e6022" => :mavericks
  end

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "'(- 1 1)'"
  end
end
