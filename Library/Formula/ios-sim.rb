require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/archive/1.8.1.tar.gz'
  sha1 '888466262bceaeaefc2658c0d932096877a805dd'

  def install
    rake "install", "prefix=#{prefix}"
  end
end
