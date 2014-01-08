require 'formula'

class Chuck < Formula
  homepage 'http://chuck.cs.princeton.edu/'
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.3.2.0.tgz'
  sha1 'a684ef41848a55de84e714dc6f644c38a1b69fd5'

  def install
    cd "src" do
      system "make osx"
      bin.install "chuck"
    end
    (share/'chuck').install "examples/"
  end
end
