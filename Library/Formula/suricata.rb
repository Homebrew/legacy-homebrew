require 'formula'

class Suricata < Formula
  url 'http://www.openinfosecfoundation.org/download/suricata-1.0.3.tar.gz'
  homepage 'http://openinfosecfoundation.org/index.php/download-suricata'
  md5 '7c612349fd63a459ded235956769a74f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
