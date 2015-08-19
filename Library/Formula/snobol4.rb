class Snobol4 < Formula
  desc "SNOBOL4 programming language"
  homepage "http://www.snobol4.org/"
  url "ftp://ftp.ultimate.com/snobol/snobol4-1.5.tar.gz"
  sha256 "9f7ec649f2d700a30091af3bbd68db90b916d728200f915b1ba522bcfd0d7abd"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
