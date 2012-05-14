require 'formula'

class IosSim < Formula
  url 'https://github.com/phonegap/ios-sim/tarball/1.4'
  homepage 'https://github.com/phonegap/ios-sim'
  md5 '5186b9f01be4e9b75d66ea6ebfd85f97'

  def install
    system "rake install prefix='#{prefix}'"
  end
end
