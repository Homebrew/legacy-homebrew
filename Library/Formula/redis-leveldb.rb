class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https://github.com/KDr2/redis-leveldb"
  url "https://github.com/KDr2/redis-leveldb/archive/v1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  head "https://github.com/KDr2/redis-leveldb.git"

  bottle do
    cellar :any
    sha256 "bc87b077a7782bdc7d117f1aaafe788bc7fe954434ddc5263b83bf04f9d9e151" => :yosemite
    sha256 "ab18b0f70c39fb6a786c7a4efb264176ce8debcb6e6caf19ec01bf062c48e6bc" => :mavericks
    sha256 "cebb22e111395ed877ba8172f12481b25bbeede765f8d00f74bfab97746b6576" => :mountain_lion
  end

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
