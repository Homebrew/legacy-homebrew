require 'formula'

class Cdparanoia <Formula
  url 'http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz'
  homepage 'http://www.xiph.org/paranoia/'
  md5 'b304bbe8ab63373924a744eac9ebc652'

  def patches
    [
     "http://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/osx_interface.patch",
     "http://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff"
    ]
  end

  def install
    system "autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--prefix=#{prefix}", "--mandir=#{man}"
    system "make all"
    system "make install"
  end
end
