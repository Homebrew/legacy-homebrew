require 'formula'

class Httpry < Formula
  url 'http://dumpsterventures.com/jason/httpry/httpry-0.1.5.tar.gz'
  homepage 'http://dumpsterventures.com/jason/httpry/'
  md5 '7fbba29eaeec1fd6b25e6fa3a12be25d'

  depends_on 'bsdmake' => :build if MacOS.xcode_version.to_f >= 4.3

  def install
    system "bsdmake"
    bin.install 'httpry'
    man1.install 'httpry.1'
  end
end
