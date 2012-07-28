require 'formula'

class Realpath < Formula
  homepage 'https://github.com/morgant/realpath'
  url 'https://github.com/morgant/realpath/tarball/realpath-2012-03-26'
  sha1 '68e3a73bc96baeb771e22d8f18ad90522610049e'
  version "0.2"

  def install
    bin.install 'realpath'
  end

  def test
    system "realpath"
  end
end
