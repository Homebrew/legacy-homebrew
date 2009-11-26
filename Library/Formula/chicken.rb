require 'formula'

class Chicken <Formula
  url 'http://www.call-with-current-continuation.org/chicken-4.2.0.tar.gz'
  homepage 'http://www.call-with-current-continuation.org/'
  md5 '4705b7634447a571ff083f435c110fe3'

  def install
    ENV.deparallelize
    settings = "PREFIX=#{prefix} PLATFORM=macosx ARCH=x86-64"
    system "make #{settings}"
    system "make install #{settings}"
  end
end
