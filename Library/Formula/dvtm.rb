require "formula"

class Dvtm < Formula
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.13.tar.gz"
  sha1 "8a4fc2440faa3050244e5a492fb6766899e0c0d7"
  head "git://repo.or.cz/dvtm.git"

  def install
    inreplace "config.mk", "LIBS = -lc -lutil -lncursesw", "LIBS = -lc -lutil -lncurses"
    inreplace "config.mk", 'CFLAGS += -std=c99 -Os ${INCS} -DVERSION=\"${VERSION}\" -DNDEBUG -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700', 'CFLAGS += -std=c99 -Os ${INCS} -DVERSION=\"${VERSION}\" -DNDEBUG'
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    expected = "dvtm-0.13 \xC2\xA9 2007-2014 Marc Andr\xC3\xA9 Tanner\n"
    version = `dvtm -v`
    assert_equal expected, version
  end
end
