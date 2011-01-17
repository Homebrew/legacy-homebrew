require 'formula'

# References:
# * http://smalltalk.gnu.org/wiki/building-gst-guides
#
# Note that we build 32-bit, which means that 64-bit
# optional dependencies will break the build. You may need
# to "brew unlink" these before installing GNU Smalltalk and
# "brew link" them afterwards:
# * gdbm

class GnuSmalltalk <Formula
  url 'ftp://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.2.tar.gz'
  homepage 'http://smalltalk.gnu.org/'
  sha1 'a985d69e4760420614c9dfe4d3605e47c5eb8faa'

  # 'gmp' is an optional dep, it is built 64-bit on Snow Leopard
  # (and this brew is forced to build in 32-bit mode.)

  depends_on 'readline'

  def install
    fails_with_llvm "Codegen problems with LLVM"

    # 64-bit version doesn't build, so force 32 bits.
    ENV.m32

    if snow_leopard_64? and Formula.factory('gdbm').installed?
      onoe "A 64-bit gdbm will cause linker errors"
      puts <<-EOS.undent
        GNU Smalltak doesn't compile 64-bit clean on OS X, so having a
        64-bit gdbm installed will break linking you may want to do:
          $ brew unlink gdbm
          $ brew install gnu-smalltalk
          $ brew link gdbm
      EOS
    end

    readline = Formula.factory('readline')

    # GNU Smalltalk thinks it needs GNU awk, but it works fine
    # with OS X awk, so let's trick configure.
    here = Dir.pwd
    system "ln -s /usr/bin/awk #{here}/gawk"
    ENV['AWK'] = "#{here}/gawk"

    ENV['FFI_CFLAGS'] = '-I/usr/include/ffi'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{readline.lib}"
    system "make"
    ENV.j1 # Parallel install doesn't work
    system "make install"
  end
end
