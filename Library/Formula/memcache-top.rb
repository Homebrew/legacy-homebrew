require 'formula'

class MemcacheTop < Formula
  homepage 'http://code.google.com/p/memcache-top/'
  url 'http://memcache-top.googlecode.com/files/memcache-top-v0.6'
  version '0.6'
  sha1 'eaac357e13ac2a531c28081783fdcc3ddbe98ede'

  def install
    bin.install 'memcache-top-v0.6' => 'memcache-top'
  end
end
