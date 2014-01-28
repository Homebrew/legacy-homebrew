require 'formula'

class Minised < Formula
  homepage 'http://www.exactcode.de/site/open_source/minised/'
  url 'http://dl.exactcode.de/oss/minised/minised-1.14.tar.gz'
  sha1 'ddfd770b911ae482fd79a6d8f5f1e731ad2784e8'

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end
end
