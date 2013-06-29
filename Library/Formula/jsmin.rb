require 'formula'

class Jsmin < Formula
  homepage 'http://www.crockford.com/javascript/jsmin.html'
  url 'https://github.com/douglascrockford/JSMin/archive/67754f619d0562f583dc5e869d2c05c0af21aca9.tar.gz'
  version '2013-02-25'
  sha1 '71633539862e0ab68ed74a92127304794ec8bfa9'

  def install
    system 'cc jsmin.c -o jsmin'
    bin.install 'jsmin'
  end
end
