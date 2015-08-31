class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.13.tar.gz"
  sha256 "8e96926b194159835e4c0ee754432e1af059b8768efee6de688187a58f4f4434"

  bottle do
    cellar :any
    revision 1
    sha256 "9f5e064a29837a8aef87a8ebe2d9b576f9881fa669e085f7518b8344c5bc39ab" => :yosemite
    sha256 "7e2bf1f95f49c4d5f111737d171fd333e3a6d89a435d74f76163d1b1291a6138" => :mavericks
    sha256 "ada906d1b4fa26f73ce3aa4b393c6c9d7ec76bf50663e2ff748d143f6c3518bc" => :mountain_lion
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
