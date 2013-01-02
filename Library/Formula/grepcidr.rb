require 'formula'

class Grepcidr < Formula
  url 'http://www.pc-tools.net/files/unix/grepcidr-1.3.tar.gz'
  homepage 'http://www.pc-tools.net/unix/grepcidr/'
  sha1 '36245b1efe497ecbe3928d2b2c6db68c0a52d179'

  def install
    system "make"
    bin.install 'grepcidr'
  end
end
