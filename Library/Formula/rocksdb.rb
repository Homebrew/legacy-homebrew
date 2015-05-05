require "formula"

class Rocksdb < Formula
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.10.2.tar.gz"
  sha256 "5ace408b12e5e5c836c9ba0b1bd57662784d15820cd02b203459b3ac2e01fde7"

  bottle do
    cellar :any
    sha1 "d073fd02dc41f54cb226e3ae58483e4e77341656" => :yosemite
    sha1 "82f908bd82a241543b4326763e2991ee5cd8b1e7" => :mavericks
    sha1 "c6cdd565ffb3069db9fc756e9546c4d9c2e367aa" => :mountain_lion
  end

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"

  def install
    ENV.cxx11
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
