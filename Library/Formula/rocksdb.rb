require "formula"

class Rocksdb < Formula
  homepage "http://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.1.tar.gz"
  sha1 "547db6b5840062c4fd2318ed7a4d3a873c8b313b"
  head "https://github.com/facebook/rocksdb.git"

  option "with-shared", "build shared library"

  depends_on "snappy"

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "static_lib"
    system "make", "shared_lib" if build.with? "shared"

    include.install Dir["include/*"]
    lib.install "librocksdb.a"
    lib.install "librocksdb.dylib" if build.with? "shared"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/db.h>
      using namespace rocksdb;
      int main() {
        DB* db;
        Options options;
        options.create_if_missing = true;
        Status status = DB::Open(options, "#{testpath}/testdb", &db);
        assert(status.ok());
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
                                "-stdlib=libc++",
                                "-lstdc++",
                                "-lrocksdb",
                                "-lsnappy",
                                "-lz",
                                "-lbz2"
  end
end
