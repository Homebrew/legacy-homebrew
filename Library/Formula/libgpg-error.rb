require 'formula'

class LibgpgError < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.12.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.12.tar.bz2'
  sha1 '259f359cd1440b21840c3a78e852afd549c709b8'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
