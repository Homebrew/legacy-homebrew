require 'formula'

class Scrypt < Formula
  homepage 'https://www.tarsnap.com/scrypt.html'
  url 'https://www.tarsnap.com/scrypt/scrypt-1.1.6.tgz'
  sha256 'dfd0d1a544439265bbb9b58043ad3c8ce50a3987b44a61b1d39fd7a3ed5b7fb8'

  depends_on 'openssl'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
