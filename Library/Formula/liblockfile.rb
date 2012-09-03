require 'formula'

class Liblockfile < Formula
  url 'http://mirrors.kernel.org/debian/pool/main/libl/liblockfile/liblockfile_1.08.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.08.orig.tar.gz'
  homepage 'http://packages.qa.debian.org/libl/liblockfile.html'
  sha1 'c3b67ca81abb45aa02c75c2a99f0e387b897fe73'

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
