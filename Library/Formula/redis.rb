require 'formula'

class Redis <Formula
  url 'http://redis.googlecode.com/files/redis-1.2.2.tar.gz'
  homepage 'http://code.google.com/p/redis/'
  sha1 '66b65a12cbc6968b9375c861d8ddb4d74abfa79d'

  def install
    %w( run db/redis log ).each do |path|
      (var+path).mkpath
    end

    ENV.gcc_4_2
    system "make"
    bin.install %w( redis-benchmark redis-cli redis-server )
    
    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
    end
    
    etc.install "redis.conf"
  end

  def caveats
    "To start redis: $ redis-server #{etc}/redis.conf"
  end
end
