require 'formula'

class Chuck < Formula
  homepage 'http://chuck.cs.princeton.edu/'
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.3.1.3.tgz'
  sha1 '67d45941535f311b7700ed4958a4ad6929bca284'

  def install
    cd "src" do
      system "make osx"
      bin.install "chuck"
    end
    (share/'chuck').install "examples/"
  end
end
