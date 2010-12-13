require 'formula'

class GpgAgent < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.15.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '3596668fb9cc8ec0714463a5009f990fc23434b0'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pth'
  depends_on 'pinentry'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-agent-only"
    system "make install"
  end
end
