require 'formula'

class Launch < Formula
  homepage 'http://web.sabi.net/nriley/software/'
  head 'https://github.com/nriley/launch.git'
  url 'http://sabi.net/nriley/software/launch-1.2.2.tar.gz'
  sha1 'd6fabdb495d3395460148bb99341cbf0f1b9d575'

  depends_on :xcode

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-configuration", "Deployment", "SYMROOT=build"

    man1.install gzip('launch.1')
    bin.install 'build/Deployment/launch'
  end
end
