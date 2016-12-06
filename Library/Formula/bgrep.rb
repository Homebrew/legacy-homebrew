require 'formula'

class Bgrep < Formula
  url 'https://github.com/tmbinc/bgrep/raw/master/bgrep.c'
  version '0.2'
  homepage 'https://github.com/tmbinc/bgrep'
  md5 'b9a239d091bd3b1b62c681eb7748f2c2'

  def install
    system "gcc", "-O2", "-x", "c", "-o", "bgrep", "bgrep.c"
    bin.install "bgrep"
  end
end
