require 'formula'

class Tth < Formula
  homepage 'http://hutchinson.belmont.ma.us/tth/'
  url 'http://hutchinson.belmont.ma.us/tth/tth-noncom/tth_C.tgz'
  sha1 '6242030c1d55499e5f505ac870a0b64b72874cd9'
  version '4.03'

  def install
    system "#{ENV.cc} -o tth tth.c"
    bin.install %w(tth latex2gif ps2gif ps2png)
    man1.install 'tth.1'
  end
end
