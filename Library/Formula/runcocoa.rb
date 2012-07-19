require 'formula'

class Runcocoa < Formula
  homepage 'https://github.com/michaeltyson/Commandline-Cocoa'
  url 'https://github.com/michaeltyson/Commandline-Cocoa/tarball/834f73b4b5d0d2be0d336c9869973f5f0db55949'
  sha1 '76f95d2b0f893ff635e0ff2487ffc26846d995f3'
  version '20120108'

  def install
    bin.install 'runcocoa.sh' => 'runcocoa'
    bin.install 'runc.sh' => 'runc'
  end
end
