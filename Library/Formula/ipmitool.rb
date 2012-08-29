require 'formula'

class Ipmitool < Formula
  homepage 'http://ipmitool.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.11/ipmitool-1.8.11.tar.bz2'
  sha1 '9f6667c3d47ca56f8c0803ea7849ed375133cb72'

  fails_with :clang do
    cause 'error: non-void functions should return a value'
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
