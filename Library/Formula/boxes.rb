require 'formula'

class Boxes < Formula
  homepage 'http://boxes.thomasjensen.com/'
  url 'http://boxes.thomasjensen.com/download/boxes-1.1.src.tar.gz'
  md5 'd2ef9fa28a87bf32b3fe0c47ab82fa97'

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config", "CC=#{ENV.cc}"

    # No make install have to manually copy files
    bin.install 'src/boxes'
    man1.install 'doc/boxes.1'
    share.install 'boxes-config'
  end
end
