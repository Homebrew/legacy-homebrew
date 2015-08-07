class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "https://github.com/mfikes/planck/archive/1.3.tar.gz"
  sha256 "82dabffc03cf16527a867782714f81b93e7bb9e7a5db9d3992b74cc74c169790"

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
    system "./build.sh"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "'(- 1 1)'"
  end
end
