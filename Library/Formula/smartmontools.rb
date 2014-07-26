require 'formula'

class Smartmontools < Formula
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  url 'https://downloads.sourceforge.net/project/smartmontools/smartmontools/6.3/smartmontools-6.3.tar.gz'
  sha1 '716c5dc339d408d628c55dbe69028b1561df4c7e'

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
