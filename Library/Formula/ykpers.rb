require 'formula'

class Ykpers < Formula
  url 'http://yubikey-personalization.googlecode.com/files/ykpers-1.6.3.tar.gz'
  homepage 'http://code.google.com/p/yubikey-personalization/'
  md5 '585b73f18a74d85a920065abcc1d82f7'

  depends_on 'libyubikey'

  def install
    libyubikey_prefix = Formula.factory('libyubikey').prefix
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}"
    system "make install"
  end
end
