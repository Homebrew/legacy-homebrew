class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.5.0.tar.bz2"
  sha256 "a0e7b47af38330f188970998c8e5039134dadf6f2e3f2c00d7efdae272a4338d"

  bottle do
    sha1 "9d99ec472782f23cd5cd05a215cb3b8418b28032" => :yosemite
    sha1 "23393e359956ed3b1c2717de019e5c803702273c" => :mavericks
    sha1 "2eefd32770ca966b3c604f795af45a9717d15a13" => :mountain_lion
  end

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
