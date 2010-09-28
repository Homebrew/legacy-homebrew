require 'formula'

class Liblockfile <Formula
  url 'http://ftp.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.08.orig.tar.gz'
  homepage 'http://packages.qa.debian.org/libl/liblockfile.html'
  md5 'c24e2dfb4a2aab0263fe5ac1564d305e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--with-mailgroup=staff",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath
    system "make"
    system "make install"
  end
end
