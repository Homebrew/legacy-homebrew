require 'formula'

class Tigger < Formula
  url 'http://www.tiggerlovesdevs.com/tigger.tar.bz2'
  version '1.0'
  homepage 'http://tiggerlovesdevs.com/'
  md5 '1b9ee03276aad689dba352d6ed72fdc8'

  def install
    system "sudo make"
  end
end
