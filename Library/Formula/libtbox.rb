class Libtbox < Formula
  desc "The Cross-platform C development library"
  homepage "https://github.com/waruqi/tbox"
  url "https://github.com/waruqi/tbox/archive/v1.5.1.tar.gz"
  mirror "http://tboox.net/release/tbox/tbox-v1.5.1.tar.gz"
  sha256 "9a960a7b362c0a7f694aee505a1ab4d6677cd54542bcf200eda4fcb56f97f76b"
  head "https://github.com/waruqi/tbox.git"

  option "enable-debug", "Build with debug support"

  option "without-zlib", "Disable Zlib compression library"
  option "without-pcre", "Disable Pcre regular expressions library"
  option "without-pcre2", "Disable Pcre2 regular expressions library with a new API"
  option "without-mysql", "Disable Mysql database"
  option "without-sqlite", "Disable Sqlite database"
  option "without-openssl", "Disable Openssl SSL/TLS cryptography library"
  option "without-mbedtls", "Disable Mbedtls Cryptographic & SSL/TLS library"

  option "without-xml", "Disable Xml module"
  option "without-zip", "Disable Zip module"
  option "without-asio", "Disable Asio module"
  option "without-regex", "Disable Regular expressions module"
  option "without-object", "Disable Object module"
  option "without-thread", "Disable Thread module"
  option "without-network", "Disable Network module"
  option "without-charset", "Disable Charset module"
  option "without-database", "Disable Database module"

  depends_on "pcre" => :optional
  depends_on "pcre2" => :optional
  depends_on "lzlib" => :optional
  depends_on "mysql" => :optional
  depends_on "sqlite" => :optional
  depends_on "openssl" => :optional
  depends_on "mbedtls" => :optional

  depends_on "xmake" => :build

  def install
    args = ["--demo=false"]
    args << "--mode=debug" if build.include? "enable-debug"

    args << "--zlib=false" if build.without? "zlib"
    args << "--pcre=false" if build.without? "pcre"
    args << "--pcre2=false" if build.without? "pcre2"
    args << "--mysql=false" if build.without? "mysql"
    args << "--sqlite3=false" if build.without? "sqlite"
    args << "--openssl=false" if build.without? "openssl"
    args << "--polarssl=false" if build.without? "mbedtls"

    args << "--xml=false" if build.without? "xml"
    args << "--zip=false" if build.without? "zip"
    args << "--asio=false" if build.without? "asio"
    args << "--regex=false" if build.without? "regex"
    args << "--object=false" if build.without? "object"
    args << "--thread=false" if build.without? "thread"
    args << "--network=false" if build.without? "network"
    args << "--charset=false" if build.without? "charset"
    args << "--database=false" if build.without? "database"

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
    links = ["-ltbox"]
    links << "-lz" if build.with? "zlib"
    links << "-lpcre" if build.with? "pcre"
    links << "-lpcre2-8" if build.with? "pcre2"
    links << "-lmysqlclient" if build.with? "mysql"
    links << "-lsqlite3" if build.with? "sqlite"
    links << "-lssl" if build.with? "openssl"
    links << "-lcrypto" if build.with? "openssl"
    links << "-lmbedtls" if build.with? "mbedtls"
    system ENV.cc, "test.c", "-L#{lib}", *links, "-I#{include}", "-o", "test"
    system "./test"
  end
end
