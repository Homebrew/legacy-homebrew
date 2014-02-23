require 'formula'

class Concurrencykit < Formula
  homepage 'http://concurrencykit.org'
  url 'http://concurrencykit.org/releases/ck-0.3.4.tar.gz'
  sha1 'bf32af29ca174f068ed8772aed1647ab3d474264'

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
