require "formula"

class YubikeyPersonalization < Formula
  homepage "http://opensource.yubico.com/yubikey-personalization"
  url "https://github.com/Yubico/yubikey-personalization/archive/v1.15.2.tar.gz"
  sha1 "f65cfbd7f05c7f28fe4e3272149ad275dcdf4f42"

  depends_on "autoconf"   => :build
  depends_on 'automake'   => :build
  depends_on 'libtool'    => :build
  depends_on 'pkg-config' => :build

  depends_on "libyubikey"

  depends_on "json-c"     => :optional

  def install
    system "autoreconf",  "--install", "--force", "--verbose"
    system "./configure"
    system "make", "install"
  end

  test do
    system "ykgenerate", "aee97cb3ad288ef0add6c6b5b5fae48a", "jbLJ5n1ybZ2C", "1234", "5678", "91", "01"
  end
end
