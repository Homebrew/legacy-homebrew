require 'formula'

class Pit < Formula
  url 'https://github.com/michaeldv/pit/tarball/0.1.0'
  homepage 'http://github.com/michaeldv/pit'
  sha1 'c03e5d6b1ad0a59124be45aca9395dafac5260a4'

  def install
    system "make"
    bin.install "bin/pit"
  end
end
