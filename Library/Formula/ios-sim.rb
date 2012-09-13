require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/tarball/1.5.1'
  sha1 'ccacb1cec833a766c0960b7f400330a5d0664cbd'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
