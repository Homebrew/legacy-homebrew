require 'formula'

class Lsusb < Formula
  homepage 'https://github.com/jlhonora/lsusb'
  url 'https://raw.github.com/jlhonora/lsusb/master/lsusb-0.1.tar.gz'
  sha1 '46556b26ed9b6086cf724bdb4e573ff4de16517c'

  head 'https://github.com/jlhonora/lsusb.git'

  def install
    bin.install 'lsusb'
    man1.install 'man/lsusb.1'
  end

end
