require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/archive/1.8.2.tar.gz'
  sha1 '4328b3c8e6b455631d52b7ce5968170c9769eb1e'
  head 'https://github.com/phonegap/ios-sim.git'

  depends_on :macos => :lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end
