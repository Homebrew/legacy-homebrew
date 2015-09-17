class Ratfor < Formula
  version "1.02"
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.02.tar.gz"
  sha256 "daf2971df48c3b3908c6788c4c6b3cdfb4eaad21ec819eee70a060956736ea1c"

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
