require 'formula'

class Cdecl <Formula
  url 'http://cdecl.org/files/cdecl-blocks-2.5.tar.gz'
  homepage 'http://cdecl.org/'
  md5 'c1927e146975b1c7524cbaf07a7c10f8'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", "#{ENV.cflags} -DBSD -DUSE_READLINE"
      s.change_make_var! "LIBS", "-lreadline"
      s.change_make_var! "BINDIR", bin
      s.change_make_var! "MANDIR", man1
    end
    system "make"
    bin.mkdir
    man1.mkpath
    system "make install"
  end
end
