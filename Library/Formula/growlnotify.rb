require 'formula'

class Growlnotify <Formula
  url 'https://github.com/indirect/growlnotify/tarball/v1.2'
  md5 '9941d5c49862f5391877023fc3baec49'
  homepage 'http://growl.info/extras.php#growlnotify'

  def install
    bin.install "growlnotify"
    man1.install gzip("growlnotify.1")
  end
end
