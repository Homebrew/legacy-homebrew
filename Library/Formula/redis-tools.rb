require 'formula'

class RedisTools <Formula
  head 'git://github.com/antirez/redis-tools.git'
  homepage 'https://github.com/antirez/redis-tools'

  def install
    system "make"
    bin.install ["redis-load", "redis-stat"]
  end
end
