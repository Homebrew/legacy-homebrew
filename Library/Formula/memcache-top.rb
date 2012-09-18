require 'formula'

class MemcacheTop < Formula
  url 'http://memcache-top.googlecode.com/files/memcache-top-v0.6'
  homepage 'http://code.google.com/p/memcache-top/'
  sha1 'eaac357e13ac2a531c28081783fdcc3ddbe98ede'
  version '0.6'

  def install
    bin.install 'memcache-top-v0.6' => 'memcache-top'
  end
end
