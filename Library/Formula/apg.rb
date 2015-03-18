class Apg < Formula
  homepage "http://www.adel.nursat.kz/apg/"
  url "http://www.adel.nursat.kz/apg/download/apg-2.2.3.tar.gz"
  sha256 "69c9facde63958ad0a7630055f34d753901733d55ee759d08845a4eda2ba7dba"

  def install
    system "make", "standalone",
                   "CC=#{ENV.cc}",
                   "FLAGS=#{ENV.cflags}",
                   "LIBS=", "LIBM="

    bin.install "apg", "apgbfm"
    man1.install "doc/man/apg.1", "doc/man/apgbfm.1"
  end

  test do
    system bin/"apg", "-a", "1", "-M", "n", "-n", "3", "-m", "8", "-E", "23456789"
  end
end
