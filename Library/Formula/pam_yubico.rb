require 'formula'

class PamYubico < Formula
  homepage 'http://code.google.com/p/yubico-pam/'
  url 'http://yubico-pam.googlecode.com/files/pam_yubico-2.11.tar.gz'
  sha1 'e841ab473fee7c28af96e4d18fef427a8e1a947b'

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
