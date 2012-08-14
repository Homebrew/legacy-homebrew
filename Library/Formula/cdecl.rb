require 'formula'

class Cdecl < Formula
  homepage 'http://cdecl.org/'
  url 'http://cdecl.org/files/cdecl-blocks-2.5.tar.gz'
  md5 'c1927e146975b1c7524cbaf07a7c10f8'

  def install
    # Fix namespace clash with Lion's getline
    inreplace "cdecl.c", "getline", "cdecl_getline"

    bin.mkpath
    man1.mkpath

    ENV.append 'CFLAGS', '-DBSD -DUSE_READLINE -std=gnu89'

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LIBS=-lreadline",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end
end
