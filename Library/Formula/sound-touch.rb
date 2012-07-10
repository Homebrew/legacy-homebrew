require 'formula'

class SoundTouch < Formula
  homepage 'http://www.surina.net/soundtouch/'
  url 'http://www.surina.net/soundtouch/soundtouch-1.6.0.tar.gz'
  sha256 '8776edaf7299ffe1e8c97285f020365a63c0e01aa4f6f7c5fd1d011c0ded278f'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    # SoundTouch has a small amount of inline assembly. The assembly has two labeled
    # jumps. When compiling with gcc optimizations the inline assembly is duplicated
    # and the symbol label occurs twice causing the build to fail.
    ENV.no_optimization
    # 64bit causes soundstretch to segfault when ever it is run.
    ENV.m32

    # The tarball doesn't contain a configure script, so we have to bootstrap.
    system "/bin/sh bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
