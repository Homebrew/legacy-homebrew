require 'formula'

class Launch < Formula
  homepage 'http://web.sabi.net/nriley/software/'
  url 'http://sabi.net/nriley/software/launch-1.2.tar.gz'
  sha1 '173b75081caf451f3d3a49630bbe5c5b7e7ab17d'

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
