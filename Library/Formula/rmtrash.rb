require 'formula'

class Rmtrash < Formula
  url 'http://www.nightproductions.net/downloads/rmtrash_source.tar.gz'
  homepage 'http://www.nightproductions.net/cli.htm'
  sha1 '3e24ca03c2aadcb804681b4790177569ac83a8c6'
  version '0.3.3'

  def install
    system "make LDFLAGS='-framework Foundation -prebind' all"
    man1.install gzip("rmtrash.1")
    bin.install "rmtrash"
  end
end
