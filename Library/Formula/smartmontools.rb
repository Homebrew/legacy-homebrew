require 'formula'

class Smartmontools < Formula
  url 'http://downloads.sourceforge.net/project/smartmontools/smartmontools/5.41/smartmontools-5.41.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/smartmontools/'
  md5 '4577886bea79d4ff12bd9a7d323ce692'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"
  end
end
