require 'formula'

class Smartmontools < Formula
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  url 'https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.2/smartmontools-6.2.tar.gz'
  sha1 '37848ff5103d68b672463a30cd99e7d23d6696a5'

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
