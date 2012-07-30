require 'formula'

class PamYubico < Formula
  homepage 'http://code.google.com/p/yubico-pam/'
  url 'http://yubico-pam.googlecode.com/files/pam_yubico-2.12.tar.gz'
  sha1 '37bc2c19b3aaa43f2394eb33241ce95fe37c24c6'

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
