require "formula"

class Guile < Formula
  desc "GUILE: GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "http://ftpmirror.gnu.org/guile/guile-2.0.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-2.0.11.tar.gz"
  sha1 "3cdd1c4956414bffadea13e5a1ca08949016a802"
  revision 1

  bottle do
    revision 1
    sha1 "67bd9b8050bded7916db3622d7abd896e1376eac" => :yosemite
    sha1 "818e7ac90634b60bcbf44509a512b542b0a87bd8" => :mavericks
    sha1 "55790b96275804b2e5952b60e1071a318f3b1518" => :mountain_lion
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
    system "make install"

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
