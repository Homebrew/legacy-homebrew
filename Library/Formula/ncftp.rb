require 'formula'

class Ncftp < Formula
  homepage 'http://www.ncftp.com'
  url 'ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.gz'
  sha1 'b1aafd9291e29c336fcad07ae212fe1b5b2a1c58'

  def install
    # "disable universal" doesn't seem to work.
    # If ncftp detects the 10.4 SDK, it will try to use GCC 4.0 which doesn't
    # support all of the compiler flags we set.
    # So, just disable optimizations intead.
    ENV.no_optimization
    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
