require 'formula'

class Growlnotify < Formula
  url 'https://github.com/indirect/growlnotify/tarball/v1.2.2'
  md5 'cfe9a988a0a64aba128baf363050b434'
  homepage 'http://growl.info/extras.php#growlnotify'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end
end
