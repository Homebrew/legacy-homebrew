 require 'formula'

class Sispmctl < Formula
  homepage 'http://sispmctl.sourceforge.net/'
  url 'http://sourceforge.net/projects/sispmctl/files/sispmctl/sispmctl-3.1/sispmctl-3.1.tar.gz'
  md5 '24693cae30d77c957f34cfb2c8159661'

  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
