require 'formula'

class Chicken <Formula
  url 'http://www.call-with-current-continuation.org/chicken-4.3.0.tar.gz'
  homepage 'http://www.call-with-current-continuation.org/'
  md5 '4c8e0b8100ca6537c1198a5c2555c8c0'

  def install
    ENV.deparallelize
    settings = "PREFIX=#{prefix} PLATFORM=macosx"
    settings << " ARCH=x86-64" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6
    system "make #{settings}"
    system "make install #{settings}"
  end
end
