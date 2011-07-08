require 'formula'

class Ykpers < Formula
  url 'http://yubikey-personalization.googlecode.com/files/ykpers-1.5.2.tar.gz'
  homepage 'https://github.com/Yubico/yubikey-personalization.git'
  md5 '4cd39ddb0478e0ec274d3f3622d836e5'
  head 'git://github.com/Yubico/yubikey-personalization.git'

  depends_on 'libyubikey'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
