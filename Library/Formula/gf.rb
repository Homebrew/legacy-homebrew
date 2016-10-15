require "formula"
require "language/haskell"

class Gf < Formula

  homepage "http://www.grammaticalframework.org/"

  stable do
    url "http://www.grammaticalframework.org/download/gf-3.5.tar.gz"
    sha1 "9c3d156df73b79c2121a46c6c29c571bfdd619c2"
    depends_on "haskell-platform"
  end

  def install
    system "cabal", "update"
    system "cabal", "install",
      "--bindir=#{bin}", "--libdir=#{lib}", "--datadir=#{share}"
  end

  test  do
    (testpath/"Hello.gf").write <<-EOS.undent
    abstract Hello = {
    flags startcat = Greeting ;
    cat Greeting ; Recipient ;
    fun
      Hello : Recipient -> Greeting ;
      World, Mum, Friends : Recipient ; }
    EOS

    system "gf", "--make", testpath/"Hello.gf"
    assert(File.exists?(testpath/"Hello.pgf"), "No pgf made")
  end
end
