require 'formula'

class Mon < Formula
  homepage 'https://github.com/visionmedia/mon'
  url 'https://github.com/visionmedia/mon/archive/1.2.0.tar.gz'
  sha1 '5c29c8c972d6f8f586f831cd8fc2c51e53873e16'

  def install
    system "make"
    bin.install 'mon'
  end
end
