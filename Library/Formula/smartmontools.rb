require 'formula'

class Smartmontools < Formula
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.43/smartmontools-5.43.tar.gz'
  sha1 '1e5ef96b0f061d10b1a7a7fd72d09982e7b3242d'

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
