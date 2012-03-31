require 'formula'

class LibusbDevel < Formula
  url 'https://github.com/OpenNI/OpenNI/blob/4dbf64bc45b880bfda6aa6bb2a30d1ddd03a8c65/Platform/Linux/Build/Prerequisites/libusb-1.0.8-osx.tar.bz2?raw=true'
  homepage 'http://www.libusb.org/'
  md5 '8ad20ec24b7612caf75a059a03f21dd8'

  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh" 
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "LDFLAGS=-framework IOKit -framework CoreFoundation -arch x86_64", "CFLAGS=-arch x86_64"
    system "make"
    system "make install"
  end
end
