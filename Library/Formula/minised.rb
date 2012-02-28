require 'formula'

class Minised < Formula
  homepage 'http://www.exactcode.de/site/open_source/minised/'
  url 'http://dl.exactcode.de/oss/minised/minised-1.13.tar.gz'
  md5 '2a43b1bbf1654ef7fab9d8c4f6c979a1'

  def install
    system "make" # separate steps or it won't build the binary
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end
end
