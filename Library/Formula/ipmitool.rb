require 'formula'

class Ipmitool < Formula
  homepage 'http://ipmitool.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.12/ipmitool-1.8.12.tar.bz2'
  sha1 'b895564db1196e891b60d2ab4f6d0bf5499c3453'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
