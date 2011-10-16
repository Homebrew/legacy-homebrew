require 'formula'

class Libzzip < Formula
  url 'http://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.59/zziplib-0.13.59.tar.bz2'
  homepage 'http://sourceforge.net/projects/zziplib/'
  sha1 'ddbce25cb36c3b4c2b892e2c8a88fa4a0be29a71'

  depends_on 'pkg-config' => :build
  depends_on 'sdl' => :optional

  def options
    [[ '--with-test', 'Verify the build during install using make check. (2sec)' ]]
  end

  def install
    # Remove the Linux only link flag, -export-dynamic.
    inreplace 'configure', 'ZZIPLIB_LDFLAGS="--export-dynamic"', 'ZZIPLIB_LDFLAGS=""'
    # Fix the tests to use the library search path from OSX, not Linux.
    inreplace 'test/Makefile.in', 'LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH'
    system "./configure", "--without-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-sdl"
    system "make"
    system "make -j1 check" if ARGV.include? '--with-test'
    system "make install"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/zzdir /usr"
    oh1 "The test is successful displaying the amount of compression in /usr"
  end
end
