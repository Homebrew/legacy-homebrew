require 'formula'

class Libftdi <Formula
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.17.tar.gz"
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  md5 '810c69cfaa078b49795c224ef9b6b851'

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
