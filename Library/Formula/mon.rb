require 'formula'

class Mon < Formula
  homepage 'https://github.com/visionmedia/mon'
  url 'https://github.com/visionmedia/mon/archive/1.1.1.tar.gz'
  version '1.1.1'
  sha1 '7dde195a394d47d7b5f0c69583d5ade6e8a82ef4'

  def install
  	FileUtils.mkdir_p "#{prefix}/bin"
    system "make install PREFIX=#{prefix}"
  end
end
