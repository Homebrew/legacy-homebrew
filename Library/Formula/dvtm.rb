require 'formula'

class Dvtm <Formula
  url 'http://www.brain-dump.org/projects/dvtm/dvtm-0.6.tar.gz'
  homepage 'http://www.brain-dump.org/projects/dvtm/'
  md5 'db77a3744868dd91a5ae5ad98b7df709'
  head 'git://repo.or.cz/dvtm.git'

  def install
    inreplace 'config.mk', 'LIBS = -lc -lutil -lncursesw', 'LIBS = -lc -lutil -lncurses'
    inreplace 'Makefile', 'strip -s', 'strip'
    system "make PREFIX=#{prefix} install"
  end
end
