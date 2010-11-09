require 'formula'

class Jsmin <Formula
  url 'http://www.crockford.com/javascript/jsmin.c'
  homepage 'http://www.crockford.com/javascript/jsmin.html'
  md5 '8847fd99576468d6c9e76420da0b6b55'
  version '2008-08-03'

  def install
    system 'cc jsmin.c -o jsmin'
    bin.install 'jsmin'
  end
end
