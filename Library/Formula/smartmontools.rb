require 'formula'

class Smartmontools < Formula
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.42/smartmontools-5.42.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 '4460bf9a79a1252ff5c00ba52cf76b2a'

  def install
    (var+'run').mkpath
    (var+'lib/smartmontools').mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--enable-drivedb",
                          "--enable-savestates",
                          "--enable-attributelog"
    system "make install"
  end
end
