require 'formula'

class Ncftp <Formula
  homepage 'http://www.ncftp.com'
  url 'ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.gz'
  md5 '685e45f60ac11c89442c572c28af4228'

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
