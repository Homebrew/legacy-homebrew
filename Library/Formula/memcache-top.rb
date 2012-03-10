require 'formula'

class MemcacheTop < Formula
  url 'http://memcache-top.googlecode.com/files/memcache-top-v0.6'
  homepage 'http://code.google.com/p/memcache-top/'
  md5 '5eb035237cb482772f898597eda26106'
  version '0.6'

  def install
    bin.install 'memcache-top-v0.6' => 'memcache-top'
  end
end
