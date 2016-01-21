class Planck < Formula
  desc "A command-line ClojureScript REPL for OS X."
  homepage "http://planck-repl.org/"
  head "https://github.com/mfikes/planck.git"
  url "https://github.com/mfikes/planck/archive/1.9.tar.gz"
  sha256 "3a12e740feda792ccad85e9d1f33798e1af4a6bf2131b41f3be27d3f3489f4be"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1a9520ac7df69486ef0fb7a62356e4338c555c97e5b6664d710dc7f07f81754" => :el_capitan
    sha256 "ccf145721a5855655bbdb86be12d315dad1652b05d4fe47530101225a3a1d912" => :yosemite
    sha256 "42162719725dcefe094f12e07bdcaa1b46603b3e1f82d989a8796271bce010ae" => :mavericks
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
