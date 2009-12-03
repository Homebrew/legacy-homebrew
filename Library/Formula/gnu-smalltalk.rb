require 'formula'

# References:
# * http://smalltalk.gnu.org/wiki/building-gst-guides

class GnuSmalltalk <Formula
  url 'ftp://ftp.gnu.org/gnu/smalltalk/smalltalk-3.1.tar.gz'
  homepage 'http://smalltalk.gnu.org/'
  md5 'fb4630a86fc47c893cf9eb9adccd4851'

  # gmp is an optional dep, but doesn't compile on 10.5
  # depends_on 'gmp' => :optional

  def install
    # Codegen problems with LLVM
    ENV.gcc_4_2
    # 64-bit version doesn't build, so force 32 bits.
    ENV.m32
    ENV['FFI_CFLAGS'] = '-I/usr/include/ffi'
    system "./configure", "--prefix=#{prefix}", "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--with-readline=/usr/lib"
    system "make"
    ENV.j1 # Parallel install doesn't work
    system "make install"
  end
end
