require 'formula'

class Filepath < Formula
  version '0.3'
  url 'https://github.com/chendo/filepath/tarball/v0.3'
  homepage 'http://github.com/chendo/filepath'
  md5 '74d03212ca4915d82b4a0c7f77bf10ac'

  def install
    system "xcodebuild"
    (bin).install 'build/Release/filepath'
  end
end

