require 'formula'

class IosSim < Formula
  url "https://github.com/Fingertips/ios-sim/tarball/master"
  version "1.3"
  homepage "https://github.com/Fingertips/ios-sim"
  md5 "64b88ea87d5af6bc959366530a6d1a61"

  def install
    system "rake install prefix='#{prefix}'"
  end
end
