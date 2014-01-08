require 'formula'

class VisionmediaWatch < Formula
  homepage 'https://github.com/visionmedia/watch'
  url 'https://github.com/visionmedia/watch/archive/0.2.1.tar.gz'
  sha1 '752006185eadb34a0ec3bdbea259c27359d886d0'

  head 'https://github.com/visionmedia/watch.git'

  conflicts_with 'watch'

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
