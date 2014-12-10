require 'formula'

class Cdecl < Formula
  homepage 'http://cdecl.org/'
  url 'http://cdecl.org/files/cdecl-blocks-2.5.tar.gz'
  sha1 '3fb349970859dfd32a7fb502cecbd3c6d8656af1'

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

  test do
    assert_equal "declare a as pointer to int",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
