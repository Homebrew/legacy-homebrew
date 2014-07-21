 require 'formula'

class Sispmctl < Formula
  homepage 'http://sispmctl.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-3.1/sispmctl-3.1.tar.gz'
  sha1 'f89d2820ca48794b80df81309910299dbc1278e1'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
