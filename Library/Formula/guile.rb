require 'formula'

class Guile < Formula
  homepage 'http://www.gnu.org/software/guile/'
  url 'http://ftpmirror.gnu.org/guile/guile-2.0.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/guile/guile-2.0.11.tar.gz'
  sha1 '3cdd1c4956414bffadea13e5a1ca08949016a802'
  revision 1

  bottle do
    sha1 "144466e2a084ea75d295b98b995690969363b33f" => :mavericks
    sha1 "ab535db3b510c80356df01a9a86e6a7f9ec1b15c" => :mountain_lion
    sha1 "79baa2dfc742e413b5492aa7a876f8ff042497ae" => :lion
  end

  head do
    url 'http://git.sv.gnu.org/r/guile.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'gettext' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :run
  depends_on 'libffi'
  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'
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
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
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
