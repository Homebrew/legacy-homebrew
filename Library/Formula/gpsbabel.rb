require 'formula'

class Gpsbabel < Formula
  homepage 'http://www.gpsbabel.org'
  # revision 4813 is version 1.5.0
  url "http://gpsbabel.googlecode.com/svn/trunk/gpsbabel", :revision => "4813"
  version "1.5.0"

  head 'http://gpsbabel.googlecode.com/svn/trunk/gpsbabel'

  depends_on 'libusb' => :optional
  depends_on "qt"

  def install
    args = ['--disable-debug', '--disable-dependency-tracking',
            "--prefix=#{prefix}", '--with-zlib=system']
    args << '--without-libusb' if build.without? 'libusb'
    system "./configure", *args
    system 'make', 'install'
  end
end
