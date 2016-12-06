require 'formula'

class Filepath < Formula
  version '0.3'
  url 'https://github.com/downloads/chendo/filepath/filepath-0.3.tar.gz'
  homepage 'http://github.com/chendo/filepath'
  md5 'c842a3bdaa8746d19bb10dface26a360'

  def install
    system "xcodebuild"
    (bin).install 'build/Release/filepath'
  end
end

