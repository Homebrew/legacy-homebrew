require "formula"
require "language/haskell"

class Gf < Formula
  include Language::Haskell::Cabal

  homepage "http://www.grammaticalframework.org/"

  depends_on 'ghc' => :build
  depends_on 'cabal-install' => :build

  stable do
    url "http://www.grammaticalframework.org/download/gf-3.5.tar.gz"
    sha1 "9c3d156df73b79c2121a46c6c29c571bfdd619c2"
  end

  def install
    cabal_sandbox do
    	cabal_install_tools 'alex', 'happy'
        cabal_install '-f-server'
    end
    cabal_clean_lib
  end

  def link
    bin.install_symlink ENV['HOME'] + "/.cabal/bin/gf"
  end

  test  do
    system 'gf', '-version'

    (testpath/"Hello.gf").write <<-EOS.undent
     abstract Hello = {
     flags startcat = Greeting ;
     cat Greeting ; Recipient ;
     fun
      Hello : Recipient -> Greeting ;
      World, Mum, Friends : Recipient ; }
    EOS
    system 'gf', '--make',
    testpath/"Hello.gf"
    assert(File.exists?(testpath/"Hello.pgf"), "No pgf made")
  end
end
