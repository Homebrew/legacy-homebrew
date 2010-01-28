require 'formula'

class Rmtrash <Formula
  url 'http://www.nightproductions.net/downloads/rmtrash_source.tar.gz'
  homepage 'http://www.nightproductions.net/cli.htm'
  md5 'fecbb879766e23ec4c918b0e13bc7e43'
  version '0.3.3'

  def install
    system "make LDFLAGS='-framework Foundation -prebind' all"
    system "gzip #{name}.1"
    man1.install "#{name}.1.gz"
    bin.install "#{name}"
  end
end
