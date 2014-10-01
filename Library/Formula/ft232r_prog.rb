require 'formula'

class Ft232rProg < Formula
  homepage 'http://rtr.ca/ft232r/'
  url 'http://rtr.ca/ft232r/ft232r_prog-1.24.tar.gz'
  sha1 '4ba0cb37dd9c19b5e82af44573b50b89ef65cc87'

  depends_on 'libftdi'
  depends_on 'libusb'

  def install
    system 'make'
    bin.install('ft232r_prog')
  end
end
