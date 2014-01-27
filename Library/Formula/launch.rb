require 'formula'

class Launch < Formula
  homepage 'http://web.sabi.net/nriley/software/'
  url 'http://sabi.net/nriley/software/launch-1.2.1.tar.gz'
  sha1 'c9d8034da5778ee973bf64c3d3acc19e143730bd'

  head 'https://github.com/nriley/launch.git'

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    system  "xcodebuild",
            "-configuration",
            "Deployment",
            " SYMROOT=build clean"
    system  "xcodebuild",
            "-configuration",
            "Deployment",
            "SYMROOT=build"
    man1.install gzip('launch.1')
    bin.install 'build/Deployment/launch'
  end
end
