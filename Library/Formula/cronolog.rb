require 'formula'

class Cronolog < Formula
  homepage "http://web.archive.org/web/20140209202032/http://cronolog.org/"
  url "http://fossies.org/linux/www/cronolog-1.6.2.tar.gz"
  sha1 "6422b7c5e87241eb31d76809a2e0eea77ae4c64e"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
