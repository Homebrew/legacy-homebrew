class Guile < Formula
  desc "GUILE: GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "http://ftpmirror.gnu.org/guile/guile-2.0.11.tar.xz"
  mirror "https://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz"
  sha256 "aed0a4a6db4e310cbdfeb3613fa6f86fddc91ef624c1e3f8937a6304c69103e2"
  revision 2

  bottle do
    sha256 "d7e7ad8d491f84c1405b82ee8ef0da5b21f551b6a0f2795bae92e8bec2f19be2" => :el_capitan
    sha256 "8e4d3e402e6eb6d95dcfc308b067beb3f7bed522e801c04f2291ffb29aab8908" => :yosemite
    sha256 "c62b53570f7ac7061820c2c3009c649ff7fbf176bddd0acc36802303ede235e2" => :mavericks
    sha256 "51f5f379e25fab5cf8fb7cede02841aa716c0e90356705be2abc6a18c6af5371" => :mountain_lion
  end

  head do
    url "http://git.sv.gnu.org/r/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  fails_with :llvm do
    build 2336
    cause "Segfaults during compilation"
  end

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  def install
    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on OS X --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<-EOS.undent
    (display "Hello World")
    (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
