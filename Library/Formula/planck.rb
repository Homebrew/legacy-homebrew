class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "https://github.com/mfikes/planck/archive/1.3.tar.gz"
  sha256 "82dabffc03cf16527a867782714f81b93e7bb9e7a5db9d3992b74cc74c169790"

  bottle do
    cellar :any
    sha256 "20a1f49178c32772373aa9b5917d2502f0828626d176f5884f1c25a4e4e6361d" => :yosemite
  end

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./build.sh"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "'(- 1 1)'"
  end
end
