require 'formula'

class PamYubico < Formula
  homepage 'http://code.google.com/p/yubico-pam/'
  url 'http://yubico-pam.googlecode.com/files/pam_yubico-2.11.tar.gz'
  md5 'f36827f7169277e446fce0706a79c5fc'

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
