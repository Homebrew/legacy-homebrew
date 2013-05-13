require 'formula'

class IosDeploy < Formula
  homepage 'https://github.com/phonegap/ios-deploy'
  url 'https://github.com/phonegap/ios-deploy/archive/1.0.tar.gz'
  sha1 '1745f32cbf5d97ac9c8642fa13c75296b5609162'

  def install
    system "make"
    bin.install "ios-deploy"
  end
end
