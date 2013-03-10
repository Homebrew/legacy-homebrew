require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz"
  sha1 '4bc6ce70c98a170ada303fbd00b8428d8a2c1aa2'

  depends_on 'libusb-compat'

  def install
    mkdir 'libftdi-build' do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
