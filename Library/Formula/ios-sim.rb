require 'formula'

class IosSim < Formula
  url "https://github.com/Fingertips/ios-sim/tarball/1.1"
  homepage "https://github.com/Fingertips/ios-sim"
  md5 "ea70e2889390844ce2a72f1345df0e69"

  def install
    system "rake install prefix='#{prefix}'"
  end
end
