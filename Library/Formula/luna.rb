require 'formula'

class Luna < Formula
  url 'https://github.com/visionmedia/luna/tarball/master'
  head 'https://github.com/visionmedia/luna'
  homepage 'http://visionmedia.github.com/luna/'
  md5 '3b1b2b59fbf5a86d3273e865e1882206'
  version 'pre0.0.1'

  def install
    system "make"
    bin.install "luna"
  end
end
