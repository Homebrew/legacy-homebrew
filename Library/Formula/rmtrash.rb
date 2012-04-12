require 'formula'

class Rmtrash < Formula
  url 'http://www.nightproductions.net/downloads/rmtrash_source.tar.gz'
  homepage 'http://www.nightproductions.net/cli.htm'
  md5 'fecbb879766e23ec4c918b0e13bc7e43'
  version '0.3.3'

  def install
    system "make LDFLAGS='-framework Foundation -prebind' all"
    man1.install gzip("rmtrash.1")
    bin.install "rmtrash"
  end
end
