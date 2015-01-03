# encoding: UTF-8

class Dvtm < Formula
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.13.tar.gz"
  sha1 "8a4fc2440faa3050244e5a492fb6766899e0c0d7"
  head "git://repo.or.cz/dvtm.git"

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "LIBS=-lc -lutil -lncurses", "install"
  end

  test do
    result = shell_output("#{bin}/dvtm -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^dvtm-[0-9.]+ © 2007-\d{4} Marc André Tanner$/, result
  end
end
