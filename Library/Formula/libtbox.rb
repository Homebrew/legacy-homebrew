class Libtbox < Formula
  desc "The Cross-platform C development library"
  homepage "https://github.com/waruqi/tbox"
  url "https://github.com/waruqi/tbox/archive/v1.5.1.tar.gz"
  mirror "http://tboox.net/release/tbox/tbox-v1.5.1.tar.gz"
  sha256 "0bd5f88482cb96de5e1a488f1dc20fd759b5a00e992762915f4c8432276462ef"
  head "https://github.com/waruqi/tbox.git"

  depends_on "xmake" => :build

  def install
    args = ["--demo=false"]
    args << "--zlib=false"
    args << "--pcre=false"
    args << "--pcre2=false"
    args << "--mysql=false"
    args << "--sqlite3=false"
    args << "--openssl=false"
    args << "--polarssl=false"

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
    system ENV.cc, "test.c", "-L#{lib}", "-ltbox", "-I#{include}", "-o", "test"
  end
end
