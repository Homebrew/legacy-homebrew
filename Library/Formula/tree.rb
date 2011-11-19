require 'formula'

class Tree < Formula
  url 'http://mama.indstate.edu/users/ice/tree/src/tree-1.6.0.tgz'
  homepage 'http://mama.indstate.edu/users/ice/tree/'
  md5 '04e967a3f4108d50cde3b4b0e89e970a'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! 'prefix', prefix
      s.change_make_var! 'MANDIR', man1
      s.change_make_var! 'CC', ENV.cc
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -fomit-frame-pointer -no-cpp-precomp"
      s.remove_make_var! 'LDFLAGS'
      s.change_make_var! 'OBJS', 'tree.o unix.o html.o xml.o hash.o color.o strverscmp.o'
    end

    system "make"
    system "make install"
  end
end
