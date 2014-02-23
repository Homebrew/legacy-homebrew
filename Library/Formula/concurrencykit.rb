require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.3.5.tar.gz'
  sha1 '4186bd44603e4aec8d63e46d1b8151fdc0ba46ef'

  head 'git://git.concurrencykit.org/ck.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CC=#{ENV.cc}"
    system "make install"
    mv lib/"libck.so.#{version}", lib/"libck.#{version}.dylib"
    ln_s "libck.#{version}.dylib",  lib/"libck.0.dylib"
    ln_s "libck.#{version}.dylib",  lib/"libck.dylib"
  end
end
