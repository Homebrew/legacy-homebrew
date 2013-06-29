require 'formula'

class Boxes < Formula
  homepage 'http://boxes.thomasjensen.com/'
  url 'http://boxes.thomasjensen.com/download/boxes-1.1.src.tar.gz'
  sha1 '1fd6e875e9b3c84f2a71f6df73d9eddb37d11c93'

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config", "CC=#{ENV.cc}"

    # No make install have to manually copy files
    bin.install 'src/boxes'
    man1.install 'doc/boxes.1'
    share.install 'boxes-config'
  end
end
