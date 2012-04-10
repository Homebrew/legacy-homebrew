require 'formula'

class Gpsbabel < Formula
  # revision 4154 is version 1.4.3
  url 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel', :revision => 4154
  version '1.4.3'
  homepage 'http://www.gpsbabel.org'
  head 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel'

  depends_on 'libusb'
  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
