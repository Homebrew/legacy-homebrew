require 'formula'

class Burl < Formula
  homepage 'https://github.com/visionmedia/burl'
  version '0.1-20120629'
  url 'https://github.com/visionmedia/burl/tarball/master'
  sha1 '1ac05631933ebed7ec823e59127f629f6ede7a22'

  def install
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "false"
  end
end
