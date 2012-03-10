require 'formula'

class Tree < Formula
  homepage 'http://mama.indstate.edu/users/ice/tree/'
  url 'http://mama.indstate.edu/users/ice/tree/src/tree-1.6.0.tgz'
  md5 '04e967a3f4108d50cde3b4b0e89e970a'

  def install
    ENV.append 'CFLAGS', '-fomit-frame-pointer'
    ENV.append 'CFLAGS', '-no-cpp-precomp' unless ENV.compiler == :clang
    objs = 'tree.o unix.o html.o xml.o hash.o color.o strverscmp.o'

    system "make", "prefix=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end
end
