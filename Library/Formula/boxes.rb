require 'formula'

class Boxes < Formula
  homepage 'http://boxes.thomasjensen.com/'
  url 'http://boxes.thomasjensen.com/download/boxes-1.1.1.src.tar.gz'
  sha1 '9b09f8c59276a3978ecaf985029b8459aa69e9c1'

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config", "CC=#{ENV.cc}"

    bin.install 'src/boxes'
    man1.install 'doc/boxes.1'
    share.install 'boxes-config'
  end
end
