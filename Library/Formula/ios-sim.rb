require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/archive/1.6.tar.gz'
  sha1 '508aee052833ce6d402fae6a5dcc769049167fba'

  def install
    rake "install", "prefix=#{prefix}"
  end
end
