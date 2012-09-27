require 'formula'

class RedisTools < Formula
  head 'https://github.com/antirez/redis-tools.git'
  homepage 'https://github.com/antirez/redis-tools'

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"
    system "make"
    bin.install ["redis-load", "redis-stat"]
  end
end
