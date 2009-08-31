require 'brewkit'

class Lua <Formula
  @url='http://www.lua.org/ftp/lua-5.1.4.tar.gz'
  @homepage=''
  @md5='d0870f2de55d59c1c8419f36e8fac150'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    inreplace 'Makefile', 'man/man1', 'share/man/man1'
    system "make macosx"
    system "make install"
  end
end
