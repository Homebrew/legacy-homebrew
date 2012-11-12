require 'formula'

class Smartmontools < Formula
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/6.0/smartmontools-6.0.tar.gz'
  sha1 '752a6c087c09b203c229da3b1506a8c40a5158ad'

  def install
    (var/'run').mkpath
    (var/'lib/smartmontools').mkpath

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
