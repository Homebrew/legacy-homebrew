require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/tarball/1.6'
  sha1 '60f9e007384ccc0a8c36ad4bd02e22f0c48104b1'

  def install
    rake "install", "prefix=#{prefix}"
  end
end
