require 'formula'

class Ccextractor < Formula
  homepage 'http://ccextractor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ccextractor/ccextractor/0.66/ccextractor.src.0.66.zip'
  sha1 'eecc4139dc84d696926115c1b6b5301b6b1774db'

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end
