require 'formula'

class Libdogleg < Formula
  homepage 'https://github.com/Oblong/libdogleg'
  url 'https://github.com/laurentbartholdi/libdogleg/zipball/compile-for-mac'
  version '0.07'
  sha1 '0831f70542f01f19439d6cfcab62218c8cf9cc50'

  def install
    system "make"
    system "make sample"
    lib.install "libdogleg.a"
    lib.install Dir['libdogleg*.dylib']
    man3.install "libdogleg.3"
    include.install "dogleg.h"
    prefix.install "sample"
  end

  def test
    system "#{prefix}/sample"
  end
end
