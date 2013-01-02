require 'formula'

class Liblockfile < Formula
  homepage 'http://packages.qa.debian.org/libl/liblockfile.html'
  url 'http://mirrors.kernel.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz'
  sha1 '6f3f170bc4c303435ab5b46a6aa49669e16a5a7d'

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
