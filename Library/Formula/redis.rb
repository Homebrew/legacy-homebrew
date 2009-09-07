require 'brewkit'

class Redis <Formula
  @url='http://redis.googlecode.com/files/redis-1.0.tar.gz'
  @homepage='http://code.google.com/p/redis/'
  @md5='0bc1f0daca6abf92cdc4f00613ee1f2a'

  def install
    system "make"

    system "mkdir -p #{prefix}/share/redis"
    system "cp -r utils client-libraries doc #{prefix}/share/redis"

    system "mkdir -p #{prefix}/bin"
    system "cp redis-cli redis-benchmark redis-server #{prefix}/bin"
  end
end
