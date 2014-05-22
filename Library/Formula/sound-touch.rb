require 'formula'

class SoundTouch < Formula
  homepage 'http://www.surina.net/soundtouch/'
  url 'http://www.surina.net/soundtouch/soundtouch-1.7.1.tar.gz'
  sha256 '385eafa438a9d31ddf84b8d2f713097a3f1fc93d7abdb2fc54c484b777ee0267'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # SoundTouch has a small amount of inline assembly. The assembly has two labeled
    # jumps. When compiling with gcc optimizations the inline assembly is duplicated
    # and the symbol label occurs twice causing the build to fail.
    ENV.no_optimization
    # 64bit causes soundstretch to segfault when ever it is run.
    ENV.m32

    system "/bin/sh", "bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
