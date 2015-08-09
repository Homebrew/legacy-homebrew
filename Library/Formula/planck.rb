class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "https://github.com/mfikes/planck/archive/1.4.tar.gz"
  sha256 "57e4fdfb3dbb80b20aa71baa40ed03fe845a442d2ddd6ba9e942b4993ed13385"

  bottle do
    cellar :any
    sha256 "20a1f49178c32772373aa9b5917d2502f0828626d176f5884f1c25a4e4e6361d" => :yosemite
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
