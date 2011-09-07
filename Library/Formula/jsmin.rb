require 'formula'

class Jsmin < Formula
  url 'https://github.com/douglascrockford/JSMin/tarball/8f62fe05856935ddcd49e364502ed98c4cf555b8'
  homepage 'http://www.crockford.com/javascript/jsmin.html'
  md5 '24a2db9f6a5337eae18d46c22de57013'
  version '2008-08-03'

  def install
    system 'cc jsmin.c -o jsmin'
    bin.install 'jsmin'
  end
end
