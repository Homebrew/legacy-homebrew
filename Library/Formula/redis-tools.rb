require 'formula'

class RedisTools <Formula
  head 'git://github.com/antirez/redis-tools.git'
  homepage 'http://code.google.com/p/redis/'

  def install
    system "make"
    bin.install ["redis-load", "redis-stat"]
  end
end
