require 'formula'

class Libftdi < Formula
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.18.tar.gz"
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  md5 '916f65fa68d154621fc0cf1f405f2726'

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
