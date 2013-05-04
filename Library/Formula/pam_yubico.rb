require 'formula'

class PamYubico < Formula
  homepage 'http://code.google.com/p/yubico-pam/'
  url 'http://yubico-pam.googlecode.com/files/pam_yubico-2.13.tar.gz'
  sha1 '63de5cc19aa89122709eede7f4f272a00945535d'

  depends_on 'pkg-config' => :build
  depends_on 'libyubikey'
  depends_on 'ykclient'
  depends_on 'ykpers'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{HOMEBREW_PREFIX}",
                          "--with-libykclient-prefix=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
