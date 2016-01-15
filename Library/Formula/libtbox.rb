class Libtbox < Formula
  desc "The Cross-platform C development library"
  homepage "https://github.com/waruqi/tbox"
  url "https://github.com/waruqi/tbox/archive/v1.5.1.tar.gz"
  mirror "http://tboox.net/release/tbox/tbox-v1.5.1.tar.gz"
  sha256 "0bd5f88482cb96de5e1a488f1dc20fd759b5a00e992762915f4c8432276462ef"
  head "https://github.com/waruqi/tbox.git"

  option "with-debug", "Build with debug support"
  option "without-zlib", "Disable Zlib compression library"
  option "without-sqlite", "Disable Sqlite database"
  option "without-openssl", "Disable Openssl SSL/TLS cryptography library"

  depends_on "xmake" => :build
  depends_on "lzlib" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "openssl" => :recommended

  def install
    args = ["--demo=false", "--pcre=false", "--pcre2=false", "--mysql=false", "--polarssl=false"]
    args << "--mode=debug" if build.with? "debug"
    args << "--zlib=false" if build.without? "zlib"
    args << "--sqlite3=false" if build.without? "sqlite"
    args << "--openssl=false" if build.without? "openssl"

    system "xmake", "config", *args
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltbox", "-lssl", "-lcrypto", "-lsqlite3", "-lz", "-I#{include}", "-o", "test"
    system "./test"
  end
end
