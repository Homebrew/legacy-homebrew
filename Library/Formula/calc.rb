class Calc < Formula
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.5.0.tar.bz2"
  sha1 "65e5a6c77f7f5f3a500959a5deafd1b89a356335"

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    readline = Formula["readline"]
    inreplace "Makefile" do |s|
      s.change_make_var! "INCDIR", "#{MacOS.sdk_path}/usr/include"
      s.change_make_var! "BINDIR", bin
      s.change_make_var! "LIBDIR", lib
      s.change_make_var! "MANDIR", man1
      s.change_make_var! "CALC_INCDIR", "#{include}/calc"
      s.change_make_var! "CALC_SHAREDIR", "#{share}/calc"
      s.change_make_var! "USE_READLINE", "-DUSE_READLINE"
      s.change_make_var! "READLINE_LIB", "-L#{readline.lib} -lreadline"
      s.change_make_var! "READLINE_EXTRAS", "-lhistory -lncurses"
    end

    system "make"
    system "make", "install"
    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
