require 'formula'

class Libdogleg < Formula
  homepage 'https://github.com/Oblong/libdogleg'
  url 'https://github.com/Oblong/libdogleg/tarball/debian/0.07'
  version '0.07'
  sha1 '80b358e087ff057f04d8c34554c8bb5a5250f331'

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
