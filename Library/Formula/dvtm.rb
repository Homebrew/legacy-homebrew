require 'formula'

class Dvtm <Formula
  url 'http://www.brain-dump.org/projects/dvtm/dvtm-0.5.2.tar.gz'
  homepage 'http://www.brain-dump.org/projects/dvtm/'
  md5 '7872b9e61705a4e9952655b3b88e4add'
  head 'git://repo.or.cz/dvtm.git'

  def install
    inreplace 'config.mk', 'LIBS = -lc -lutil -lncursesw', 'LIBS = -lc -lutil -lncurses'
    inreplace 'Makefile', 'strip -s', 'strip'
    system "make PREFIX=#{prefix} install"
  end
end
