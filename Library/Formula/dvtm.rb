require "formula"

class Dvtm < Formula
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.12.tar.gz"
  sha1 "1b433db25d9751e820fc8213874eb57fd15e5552"
  head "git://repo.or.cz/dvtm.git"

  def install
    inreplace "config.mk", "LIBS = -lc -lutil -lncursesw", "LIBS = -lc -lutil -lncurses"
    inreplace "Makefile", "strip -s", "strip"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
