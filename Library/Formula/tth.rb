require 'formula'

class Tth < Formula
  homepage 'http://hutchinson.belmont.ma.us/tth/'
  url 'http://hutchinson.belmont.ma.us/tth/tth-noncom/tth_C.tgz'
  sha1 'bc571e5916b979c1dd8e3377249db66ceee28318'
  version '4.05'

  def install
    system "#{ENV.cc} -o tth tth.c"
    bin.install %w(tth latex2gif ps2gif ps2png)
    man1.install 'tth.1'
  end
end
