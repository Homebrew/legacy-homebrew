require 'formula'

class PamYubico < Formula
  homepage 'http://opensource.yubico.com/yubico-pam/'
  url 'https://github.com/Yubico/yubico-pam/archive/2.14.tar.gz'
  sha1 'c86fd78788e6a81cadd57b23411e78bd7fab48bb'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'libyubikey'
  depends_on 'ykclient'
  depends_on 'ykpers'

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf -vfi"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{HOMEBREW_PREFIX}",
                          "--with-libykclient-prefix=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
