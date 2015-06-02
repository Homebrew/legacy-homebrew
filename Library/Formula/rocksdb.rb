require "formula"

class Rocksdb < Formula
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.10.2.tar.gz"
  sha256 "5ace408b12e5e5c836c9ba0b1bd57662784d15820cd02b203459b3ac2e01fde7"

  bottle do
    cellar :any
    sha256 "9c186ae0ae332030fdc6b89a5b97eadf576e76539225884862a9785a13a4ae7e" => :yosemite
    sha256 "c199a87e5481f6a09a4217df57c7794763b022aaf615aa180112c7001659508a" => :mavericks
    sha256 "9eab1abd9f9ec5c0c8b90a4d8fe5e386c0ac9a739c39614317702ab99497ebee" => :mountain_lion
  end

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
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
