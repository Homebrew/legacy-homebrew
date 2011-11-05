require 'formula'

class Smartmontools < Formula
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.41/smartmontools-5.41.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 '4577886bea79d4ff12bd9a7d323ce692'

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
