require 'formula'

# References:
# * http://smalltalk.gnu.org/wiki/building-gst-guides

class GnuSmalltalk <Formula
  url 'ftp://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.tar.gz'
  homepage 'http://smalltalk.gnu.org/'
  sha1 'd951714c4fc7d91d06bdc33c20905885e5d2b25f'

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
