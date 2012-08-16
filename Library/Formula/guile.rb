require 'formula'

class Guile < Formula
  homepage 'http://www.gnu.org/software/guile/'
  url 'http://ftpmirror.gnu.org/guile/guile-1.8.8.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/guile/guile-1.8.8.tar.gz'
  sha1 '548d6927aeda332b117f8fc5e4e82c39a05704f9'

  devel do
    url 'http://ftpmirror.gnu.org/guile/guile-2.0.6.tar.gz'
    mirror 'http://ftp.gnu.org/gnu/guile/guile-2.0.6.tar.gz'
    sha1 'aee330029ea48160071fdbd09271d80c92498669'
  end

  depends_on 'pkg-config' => :build
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

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula.factory('readline').prefix}"
    system "make install"

    # A really messed up workaround required on OS X --mkhl
    lib.cd { Dir["*.dylib"].each {|p| ln_sf p, File.basename(p, ".dylib")+".so" }}
  end
end
