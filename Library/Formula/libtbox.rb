class Libtbox < Formula
  desc "The Cross-platform C development library"
  homepage "https://github.com/waruqi/tbox"
  url "https://github.com/waruqi/tbox/archive/v1.5.1.tar.gz"
  mirror "http://tboox.net/release/tbox/tbox-v1.5.1.tar.gz"
  sha256 "0bd5f88482cb96de5e1a488f1dc20fd759b5a00e992762915f4c8432276462ef"
  head "https://github.com/waruqi/tbox.git"

  option "with-debug", "Build with debug support"
  option "without-zlib", "Disable Zlib compression library"
  option "without-mysql", "Disable Mysql database"
  option "without-sqlite", "Disable Sqlite database"
  option "without-openssl", "Disable Openssl SSL/TLS cryptography library"

  depends_on "xmake" => :build

  def install
    args = ["--demo=false", "--polarssl=false", "--pcre=false", "--pcre2=false", "--mysql=false"]
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
    (testpath/"xmake.lua").write <<-EOS.undent
      add_option("zlib")
        set_option_showmenu(true)
        add_option_links("z")
        add_option_linkdirs("#{lib}")
      add_option("openssl")
        set_option_showmenu(true)
        add_option_links("ssl", "crypto")
        add_option_linkdirs("#{lib}")
      add_option("sqlite3")
        set_option_showmenu(true)
        add_option_links("sqlite3")
        add_option_linkdirs("#{lib}")
      add_target("test")
        set_kind("binary")
        add_files("test.c")
        add_links("tbox")
        add_linkdirs("#{lib}")
        add_includedirs("#{include}")
        add_options("openssl", "sqlite3", "zlib")
    EOS
    system "xmake"
    system "xmake", "run", "test"
  end
end
