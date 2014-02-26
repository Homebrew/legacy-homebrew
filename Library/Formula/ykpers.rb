require 'formula'

class Ykpers < Formula
  homepage 'http://yubico.github.io/yubikey-personalization/'
  url 'http://yubico.github.io/yubikey-personalization/releases/ykpers-1.14.1.tar.gz'
  sha1 '5ecc0d6bf9c58bdf825c2d8d158361fc61852ff8'

  depends_on 'libyubikey'
  depends_on 'json-c' => :recommended
  depends_on 'pkg-config' => :build

  def install
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make check"
    system "make install"
  end
end
