require 'formula'

class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage 'https://packages.qa.debian.org/libl/liblockfile.html'
  url 'https://mirrors.kernel.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.09.orig.tar.gz'
  sha1 '6f3f170bc4c303435ab5b46a6aa49669e16a5a7d'

  bottle do
    revision 1
    sha1 "f840a4b8c6243bb9e68e3a2db5fcb833e9e4bf75" => :yosemite
    sha1 "fa0e7109ca60fbff2592eb90ec5ed449f3187bc1" => :mavericks
    sha1 "36f0780292a85dced663dd3eefb0dd266226f589" => :mountain_lion
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
