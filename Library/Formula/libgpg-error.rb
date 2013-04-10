require 'formula'

class LibgpgError < Formula
  homepage 'http://www.gnupg.org/'
  url 'http://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.11.tar.gz'
  sha1 'db05ac4a29d3f92ae736da44f359b92b6af9f7ee'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
