require 'formula'

class Guile < Formula
  homepage 'http://www.gnu.org/software/guile/'
  url 'http://ftpmirror.gnu.org/guile/guile-2.0.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/guile/guile-2.0.11.tar.gz'
  sha1 '3cdd1c4956414bffadea13e5a1ca08949016a802'

  bottle do
    sha1 "3a75eeaa7a1637dd9876636963d8f02a6ffb23bf" => :mavericks
    sha1 "6828352dd9205c9fa42701f14d7808604b7b23e1" => :mountain_lion
    sha1 "e223036d6e1e238802a421d266881ad5ddf14c16" => :lion
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
