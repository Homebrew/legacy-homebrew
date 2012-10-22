require 'formula'

class Chuck < Formula
  homepage 'http://chuck.cs.princeton.edu/'
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.3.1.2.tgz'
  sha1 '9987c8e66c0910f2fab16845b763fc16ca743a80'

  def install
    cd "src" do
      system "make osx"
      bin.install "chuck"
    end
    (share/'chuck').install "examples/"
  end
end
