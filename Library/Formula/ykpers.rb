require 'formula'

class Ykpers < Formula
  homepage 'http://yubico.github.io/yubikey-personalization/'
  url 'https://developers.yubico.com/yubikey-personalization/releases/ykpers-1.15.3.tar.gz'
  sha1 'd000478e2404d916881ef845e60732e170cd62ae'

  bottle do
    cellar :any
    sha1 "d09a8c727907e474b5e3e3605e7d268ea0f2c945" => :mavericks
    sha1 "15637a656de6c6b9fcef8f6c5e271e1c0f68dc07" => :mountain_lion
    sha1 "77cc210b284b2a4f47a53be861363bfe1684e558" => :lion
  end

  option :universal

  depends_on 'libyubikey'
  depends_on 'json-c' => :recommended
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make check"
    system "make install"
  end
end
