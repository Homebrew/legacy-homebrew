require 'formula'

class Bmon < Formula
  homepage 'http://people.suug.ch/~tgr/bmon'
  url 'http://mirrors.kernel.org/debian/pool/main/b/bmon/bmon_2.0.1.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/b/bmon/bmon_2.0.1.orig.tar.gz'
  sha1 'ef6297bbd7a5f9a351e14b2b3e9f45157b136a9c'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make" # two steps to prevent blowing up
    system "make install"
  end
end
