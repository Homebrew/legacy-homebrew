require "formula"

class Dvtm < Formula
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.13.tar.gz"
  sha1 "8a4fc2440faa3050244e5a492fb6766899e0c0d7"
  head "git://repo.or.cz/dvtm.git"

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "LIBS=-lc -lutil -lncurses", "install"
  end
end
