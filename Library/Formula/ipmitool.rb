require 'formula'

class Ipmitool < Formula
  url 'http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.11/ipmitool-1.8.11.tar.bz2'
  homepage 'http://ipmitool.sourceforge.net/'
  md5 '1d0da20add7388d64c549f95538b6858'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
