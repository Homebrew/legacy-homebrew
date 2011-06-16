require 'formula'

class Httpry < Formula
  url 'http://dumpsterventures.com/jason/httpry/httpry-0.1.5.tar.gz'
  homepage 'http://dumpsterventures.com/jason/httpry/'
  md5 '7fbba29eaeec1fd6b25e6fa3a12be25d'

  def install
    system "/usr/bin/bsdmake"
    bin.install 'httpry'
    man1.install 'httpry.1'
  end
end
