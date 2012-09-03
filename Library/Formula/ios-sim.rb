require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/tarball/1.5'
  sha1 '3f9095e091602cf0c9a447d35a2558622a87d2c1'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
