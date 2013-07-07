require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/archive/1.7.tar.gz'
  sha1 'd338873178b24779d30791b045991396bfe7ba69'

  def install
    rake "install", "prefix=#{prefix}"
  end
end
