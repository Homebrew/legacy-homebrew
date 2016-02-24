class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.5.0.tar.bz2"
  sha256 "a0e7b47af38330f188970998c8e5039134dadf6f2e3f2c00d7efdae272a4338d"

  bottle do
    sha256 "f68eb0e031534c68f3fb1c2c1d53a90c343f281b81f998cf4bfc9745a0b8d306" => :el_capitan
    sha256 "d19d417a55f14e96a944c4eb12869b93a26d0e5d74a65898c8225a3c00b9d050" => :yosemite
    sha256 "4fe6049dd1e184c4996c606c9b25c7f8fde40f2a5dab5c6eda251125db5328e0" => :mavericks
    sha256 "eb87150f3af2f86480594d99558e637ed063b6a3a3cff38331d46638e02af245" => :mountain_lion
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
      s.change_make_var! "CALC_SHAREDIR", pkgshare
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
