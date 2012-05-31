require 'formula'

class Tth < Formula
  url 'http://hutchinson.belmont.ma.us/tth/tth-noncom/tth_C.tgz'
  homepage 'http://hutchinson.belmont.ma.us/tth/'
  md5 '0c5ca8ecba950075f12c98bd9ae42087'
  version '4.00'

  def install
    system "#{ENV.cc} -o tth tth.c"
    bin.install %w(tth latex2gif ps2gif ps2png)
    man1.install 'tth.1'
  end
end
