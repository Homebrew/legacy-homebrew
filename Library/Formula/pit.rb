require 'formula'

class Pit < Formula
  homepage 'https://github.com/michaeldv/pit'
  url 'https://github.com/michaeldv/pit/tarball/0.1.0'
  sha1 'c03e5d6b1ad0a59124be45aca9395dafac5260a4'

  def install
    system "make"
    bin.install "bin/pit"
  end
end
