require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/tarball/1.5'
  md5 '91137cb2e217ca92abd2002dc6ded3d4'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
