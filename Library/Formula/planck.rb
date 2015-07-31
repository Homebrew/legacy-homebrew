class Planck < Formula
  desc "A command line ClojureScript REPL for OS X."
  homepage "http://planck.fikesfarm.com/"
  url "http://planck.fikesfarm.com/planck.gz"
  sha256 "c8f3d1b270ab1175cffda119fe186e12d5a2aa77018e212a5ad62628c13517b2"
  version "1.0"

  def install
    bin.install "planck"
  end

  test do
    system "#{bin}/planck", "-e", "'(- 1 1)'"
  end
end
