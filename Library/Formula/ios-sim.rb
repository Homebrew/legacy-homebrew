require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/tarball/1.5'
  md5 'bf2863dafd1766a9e02a5b22b132284d'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
