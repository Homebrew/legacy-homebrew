require 'formula'

class Guile < Formula
  url 'ftp://ftp.gnu.org/gnu/guile/guile-2.0.0.tar.gz'
  sha1 'e266b79b17a04a98c438e9d5dabb5210fb368d77'
  head 'git://git.sv.gnu.org/guile.git'
  homepage 'http://www.gnu.org/software/guile/'

  depends_on 'pkg-config' => :build
  depends_on 'libffi'
  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'

  # GNU Readline is required; libedit won't work.
  depends_on 'readline'

  fails_with_llvm "Segfaults during compilation."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # A really messed up workaround required on OS X --mkhl
    lib.cd { Dir["*.dylib"].each {|p| ln_sf p, File.basename(p, ".dylib")+".so" }}
  end
end
