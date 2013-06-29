require 'formula'

class Dvtm < Formula
  homepage 'http://www.brain-dump.org/projects/dvtm/'
  url 'http://www.brain-dump.org/projects/dvtm/dvtm-0.9.tar.gz'
  sha1 '74b9d1f5172fddd6839d932e483d36c6d0ef4b04'
  head 'git://repo.or.cz/dvtm.git'

  def install
    inreplace 'config.mk', 'LIBS = -lc -lutil -lncursesw', 'LIBS = -lc -lutil -lncurses'
    inreplace 'Makefile', 'strip -s', 'strip'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
