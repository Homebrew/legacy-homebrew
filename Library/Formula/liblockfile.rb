require 'formula'

class Liblockfile < Formula
  homepage 'http://packages.qa.debian.org/libl/liblockfile.html'
  url 'http://mirrors.kernel.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz'
  sha1 '6f3f170bc4c303435ab5b46a6aa49669e16a5a7d'

  bottle do
    sha1 "a9b89459cecd5b71790d69b10db1880da9e50c69" => :mavericks
    sha1 "6c8f254c0ab0b54e7d3019e793dfaaea5ba895af" => :mountain_lion
    sha1 "f22c5dd847df9b3422fe23d394411a8363a74192" => :lion
  end

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
