require "formula"

class Rocksdb < Formula
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/3.5.fb.tar.gz"
  sha1 "f8bd52914835a0839548eaca7f755128ed759991"
  version "3.5"

  bottle do
    cellar :any
    sha1 "12a0ee9a9df0395e7238ef521d394e9e9a00bd8c" => :mavericks
    sha1 "2f1b4f55088ec76beb5956a2d4e69509c99ec3f8" => :mountain_lion
    sha1 "617a97e1b14b1e0bb395ed74c55bacc1507e1f4d" => :lion
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
