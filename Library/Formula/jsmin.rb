require 'formula'

class Jsmin < Formula
  homepage 'http://www.crockford.com/javascript/jsmin.html'
  url 'https://github.com/douglascrockford/JSMin/archive/8f62fe05856935ddcd49e364502ed98c4cf555b8.tar.gz'
  version '2008-08-03'
  sha1 '7909b2574255ebd2df46f847e2ec9ef60a56933d'

  def install
    system 'cc jsmin.c -o jsmin'
    bin.install 'jsmin'
  end
end
