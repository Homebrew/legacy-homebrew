require 'formula'

class Chicken <Formula
  url 'http://code.call-cc.org/releases/4.5.0/chicken-4.5.0.tar.gz'
  md5 '753aea676a18c8dc0161dfb4d1717e20'
  homepage 'http://www.call-cc.org/'

  def install
    ENV.deparallelize
    args = ["PREFIX=#{prefix}", "PLATFORM=macosx"]
    args << "ARCH=x86-64" if snow_leopard_64?
    system "make", *args
    system "make", "install", *args
  end
end
