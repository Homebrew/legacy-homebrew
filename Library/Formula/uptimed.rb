require 'formula'

class Uptimed < Formula
  homepage 'http://podgorny.cz/moin/Uptimed'
  url 'http://podgorny.cz/uptimed/releases/uptimed-0.3.12.tar.bz2'
  sha1 '753ab59bb99d7b88a35174ce83081ad0bb224e56'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make install"
  end
end
