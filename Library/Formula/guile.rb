require 'formula'

class Guile < Formula
  homepage 'http://www.gnu.org/software/guile/'
  url 'http://ftpmirror.gnu.org/guile/guile-2.0.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/guile/guile-2.0.11.tar.gz'
  sha1 '3cdd1c4956414bffadea13e5a1ca08949016a802'

  head do
    url 'http://git.sv.gnu.org/r/guile.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'gettext' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'libffi'
  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'

  # GNU Readline is required; libedit won't work.
  depends_on 'readline'

  fails_with :llvm do
    build 2336
    cause "Segfaults during compilation"
  end

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  def install
    system './autogen.sh' if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].prefix}"
    system "make install"

    # A really messed up workaround required on OS X --mkhl
    lib.cd { Dir["*.dylib"].each {|p| ln_sf p, File.basename(p, ".dylib")+".so" }}
  end

  test do
    hello = testpath/'hello.scm'
    hello.write <<-EOS.undent
    (display "Hello World")
    (newline)
    EOS

    ENV['GUILE_AUTO_COMPILE'] = '0'

    system bin/'guile', hello
  end
end
