require 'formula'

class Chuck < Formula
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.2.1.3.tgz'
  homepage 'http://chuck.cs.princeton.edu/'
  sha1 '14de1c468294c6b324aee0023fee0116a8e5f5e0'

  def install
    system "make", "-C", "src", "osx-#{Hardware.cpu_type}"
    bin.install "src/chuck"
    (share+'chuck').install "examples/"
  end
end
