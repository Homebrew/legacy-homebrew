require 'formula'

class Garmintools < Formula
  url 'http://garmintools.googlecode.com/files/garmintools-0.10.tar.gz'
  homepage 'http://code.google.com/p/garmintools/'
  md5 '1a555a5174a82e92e0f5def1c4b01ae7'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
