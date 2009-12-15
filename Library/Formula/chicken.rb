require 'formula'

class Chicken <Formula
  url 'http://www.call-with-current-continuation.org/chicken-4.3.0.tar.gz'
  homepage 'http://www.call-with-current-continuation.org/'
  md5 '4c8e0b8100ca6537c1198a5c2555c8c0'

  def install
    ENV.deparallelize
    settings = "PREFIX=#{prefix} PLATFORM=macosx ARCH=x86-64"
    system "make #{settings}"
    system "make install #{settings}"
  end
end
