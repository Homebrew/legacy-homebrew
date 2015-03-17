class Ncftp < Formula
  homepage "http://www.ncftp.com"
  url "ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.gz"
  sha256 "ac111b71112382853b2835c42ebe7bd59acb7f85dd00d44b2c19fbd074a436c4"

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
    system "make", "install"
  end

  test do
    system "#{bin}/ncftp", "-F"
  end
end
