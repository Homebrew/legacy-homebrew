require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.19.tar.gz"
  md5 'e6e25f33b4327b1b7aa1156947da45f3'

  depends_on 'boost'
  depends_on 'libusb-compat'

  def install
    mkdir 'libftdi-build'
    Dir.chdir 'libftdi-build' do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
