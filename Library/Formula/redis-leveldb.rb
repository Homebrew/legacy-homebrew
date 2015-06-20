class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https://github.com/KDr2/redis-leveldb"
  url "https://github.com/KDr2/redis-leveldb/archive/v1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  head "https://github.com/KDr2/redis-leveldb.git"

  depends_on "libev"
  depends_on "gmp"
  depends_on "leveldb"

  def install
    inreplace "src/Makefile", "../vendor/libleveldb.a", Formula["leveldb"].opt_lib+"libleveldb.a"
    ENV.prepend "LDFLAGS", "-lsnappy"
    system "make"
    bin.install "redis-leveldb"
  end

  test do
    system "redis-leveldb", "-h"
  end
end
