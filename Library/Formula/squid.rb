require 'formula'

class NoBdb5 < Requirement
  def message; <<-EOS.undent
    This software can fail to compile when Berkeley-DB 5.x is installed.
    You may need to try:
      brew unlink berkeley-db
      brew install dsniff
      brew link berkeley-db
    EOS
  end
  def satisfied?
    f = Formula.factory("berkeley-db")
    not f.installed?
  end
end

class Squid < Formula
  url 'http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.9.tar.bz2'
  homepage 'http://www.squid-cache.org/'
  md5 '896ace723445ac168986ba8854437ce3'

  depends_on NoBdb5.new

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
  end
end
