require 'formula'

class Dvtm < Formula
  url 'http://www.brain-dump.org/projects/dvtm/dvtm-0.7.tar.gz'
  homepage 'http://www.brain-dump.org/projects/dvtm/'
  md5 'd8ef63bad5b48324ad040630c51a1c26'
  head 'git://repo.or.cz/dvtm.git'

  def install
    inreplace 'config.mk', 'LIBS = -lc -lutil -lncursesw', 'LIBS = -lc -lutil -lncurses'
    inreplace 'Makefile', 'strip -s', 'strip'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
