require "formula"

class Rocksdb < Formula
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.5.1.tar.gz"
  sha1 "20e90bf82a74677f337fd5295e126651f3333e79"

  bottle do
    cellar :any
    sha1 "1054d8930b67df3740e7e9ce0f2fd1589ac81528" => :mavericks
    sha1 "3ff7a41bcc4b0a0a32ce57b8ae3a3bfdc6612968" => :mountain_lion
    sha1 "2feff3bb8aa49090437fbe7a6d5ea3c2e5a53c42" => :lion
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
