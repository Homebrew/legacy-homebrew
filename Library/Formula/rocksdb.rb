class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-4.4.tar.gz"
  sha256 "ff79856613e628c2181c4e2e0bc98763e05a4536e0662e5d84f4d237bf40cdb8"

  bottle do
    cellar :any
    sha256 "25d487dd987400a3f23a4676d8e82525c6a8e235bffa3299ee228cf0e1747577" => :el_capitan
    sha256 "a9cdf1865a35da551d0ff71b6b2ca85f3144b60f643a63a083ebe6f155f2de31" => :yosemite
    sha256 "c4be4117fc48b746629ac7040cb645fc7e688de7a11a821514f9fd43698f6b4b" => :mavericks
  end

  option "with-lite", "Build mobile/non-flash optimized lite version"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    ENV.append_to_cflags "-DROCKSDB_LITE=1" if build.with? "lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        options.memtable_factory.reset(
                    NewHashSkipListRepFactory(16));
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v", "-std=c++11",
                                "-stdlib=libc++",
                                "-lstdc++",
                                "-lrocksdb",
                                "-lz", "-lbz2",
                                "-lsnappy", "-llz4"
    system "./db_test"
  end
end
