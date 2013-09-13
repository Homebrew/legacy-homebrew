require 'formula'

class Gpsbabel < Formula
  homepage 'http://www.gpsbabel.org'
  # revision 4199 is version 1.4.4
  url 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel', :revision => '4199'
  version '1.4.4'

  head 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel'

  depends_on 'libusb' => :optional

  def install
    args = ['--disable-debug', '--disable-dependency-tracking',
            "--prefix=#{prefix}", '--with-zlib=system']
    args << '--without-libusb' if build.without? 'libusb'
    system "./configure", *args
    system 'make', 'install'
  end
end
