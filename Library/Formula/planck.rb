class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  head "https://github.com/mfikes/planck.git"
  url "https://github.com/mfikes/planck/archive/1.6.tar.gz"
  sha256 "e734a5ccbed1b63273c06555cf61acb6f95a3b18433ba0e8ffdeadba176ccbe6"

  bottle do
    cellar :any
    sha256 "270a2c29f2ade9c35222669a9ebd6d5bc93ba9299a486c87b99662d0a8000f35" => :yosemite
    sha256 "5f032b810928a229c996be47ac13ad4035c816a2702e229f31813145c7778a3c" => :mavericks
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
