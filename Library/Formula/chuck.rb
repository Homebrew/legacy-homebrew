require 'formula'

class Chuck < Formula
  homepage 'http://chuck.cs.princeton.edu/'
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.3.3.0.tgz'
  sha1 'fdf70c860c9fabf45a8caf07830bc70548ce3bba'

  def install
    cd "src" do
      system "make osx"
      bin.install "chuck"
    end
    (share/'chuck').install "examples/"
  end
end
