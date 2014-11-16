require 'formula'

class Garmintools < Formula
  homepage 'http://code.google.com/p/garmintools/'
  url 'https://garmintools.googlecode.com/files/garmintools-0.10.tar.gz'
  sha1 'f59a761b09575d27abbf5d76811f7ec25a1cbd26'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
