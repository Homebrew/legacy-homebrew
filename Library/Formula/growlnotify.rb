require 'formula'

class Growlnotify < Formula
  url 'https://github.com/indirect/growlnotify/tarball/v1.3'
  md5 '44f771b0bafd0fc077ecc546841d9831'
  homepage 'http://growl.info/extras.php#growlnotify'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end
end
