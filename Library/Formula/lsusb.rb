require 'formula'

class Lsusb < Formula
  homepage 'https://github.com/jlhonora/lsusb'
  head 'https://github.com/jlhonora/lsusb', :using => :git

  url 'https://github.com/jlhonora/lsusb/releases/download/0.2/lsusb-0.2.tar.gz'
  sha1 '00e99f1f9fb15ae5fcb4261d354d1dac0b8ee9fb'

  def install
    bin.install 'lsusb'
    man1.install 'man/lsusb.1'
  end

end
