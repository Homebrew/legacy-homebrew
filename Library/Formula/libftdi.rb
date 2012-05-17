require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz"
  md5 '355d4474e3faa81b485d6a604b06951f'

  depends_on 'boost'
  depends_on 'libusb-compat'

  def install
    mkdir 'libftdi-build' do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
