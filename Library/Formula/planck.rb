class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "https://github.com/mfikes/planck/archive/1.3.tar.gz"
  sha256 "82dabffc03cf16527a867782714f81b93e7bb9e7a5db9d3992b74cc74c169790"

  depends_on "leiningen" => :build

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    system "./build.sh"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "'(- 1 1)'"
  end
end
