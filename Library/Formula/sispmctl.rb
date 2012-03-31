require 'formula'

class Sispmctl < Formula
  homepage 'http://sispmctl.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-3.1/sispmctl-3.1.tar.gz'
  md5 '24693cae30d77c957f34cfb2c8159661'

  depends_on 'libusb-compat' => :build
  
  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "sispmctl -v"
  end
end
