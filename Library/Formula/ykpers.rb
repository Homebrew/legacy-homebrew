require 'formula'

class Ykpers < Formula
  url 'http://yubikey-personalization.googlecode.com/files/ykpers-1.3.5.tar.gz'
  homepage 'http://code.google.com/p/yubikey-personalization/'
  md5 '9aeea5a005afcd431de3dd591400fac5'

  depends_on 'libyubikey'

  def install
    libyubikey_prefix = Formula.factory('libyubikey').prefix
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}"
    system "make install"
  end
end
