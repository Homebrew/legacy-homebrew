require 'formula'

class Growlnotify < Formula
  url 'https://github.com/josso/growlnotify/tarball/v1.2.2'
  md5 '0e7b60d5cbf074c44c1b7f0eee6ccd1c'
  homepage 'http://growl.info/extras.php#growlnotify'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end
end
