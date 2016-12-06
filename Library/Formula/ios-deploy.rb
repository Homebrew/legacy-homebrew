require 'formula'

class IosDeploy < Formula
  homepage 'https://github.com/phonegap/ios-deploy'
  url 'https://github.com/phonegap/ios-deploy/archive/1.0.tar.gz'
  sha1 'a41bb14096792c84b634c8828d01ec540e2d8793'

  def install
    system "make"
    bin.install "ios-deploy"
  end
end
