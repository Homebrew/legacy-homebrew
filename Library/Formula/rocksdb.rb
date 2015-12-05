class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.13.tar.gz"
  sha256 "8e96926b194159835e4c0ee754432e1af059b8768efee6de688187a58f4f4434"

  bottle do
    cellar :any
    sha256 "252efa6a54c536a2573a3e41163d50e9f0c04c2f3003cf0847baccf8645e7181" => :el_capitan
    sha256 "2e4c25f953d379949b4a6cc2e33acdea075531d81ec81f7310de2824d31903a3" => :yosemite
    sha256 "30af85a62545dedc435eaf2633ac38e273d9ed417a262e8248cf744ce00cdd21" => :mavericks
    sha256 "fda72e2b5e4939f14789ba7b148f59c2023297866ea228ef02a9ffaee2ddd6a2" => :mountain_lion
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
