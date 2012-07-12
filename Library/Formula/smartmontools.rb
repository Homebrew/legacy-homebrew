require 'formula'

class Smartmontools < Formula
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.43/smartmontools-5.43.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 'a1cb2c3d8cc2de377037fe9e7cef40a9'

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
