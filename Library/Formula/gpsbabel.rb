require 'formula'

class Gpsbabel < Formula
  homepage 'http://www.gpsbabel.org'
  # revision 4199 is version 1.4.4
  url 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel', :revision => '4199'
  version '1.4.4'

  head 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel'

  depends_on 'libusb'
  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
