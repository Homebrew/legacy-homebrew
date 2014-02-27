require 'formula'

class Mon < Formula
  homepage 'https://github.com/visionmedia/mon'
  url 'https://github.com/visionmedia/mon/archive/1.2.3.tar.gz'
  sha1 '9c5013332b6ecccb6368b100e6aee377e35b5bb1'

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end
end
