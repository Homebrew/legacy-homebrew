require 'formula'

class Runcocoa < Formula
  homepage 'https://github.com/michaeltyson/Commandline-Cocoa'
  url 'https://github.com/michaeltyson/Commandline-Cocoa/tarball/834f73b4b5d0d2be0d336c9869973f5f0db55949'
  md5 'ae9f074333e9b9e21c346064dc03428c'
  version '20120108'

  def install
    bin.install 'runcocoa.sh' => 'runcocoa'
    bin.install 'runc.sh' => 'runc'
  end
end
