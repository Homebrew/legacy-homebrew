# encoding: UTF-8

class Dvtm < Formula
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.13.tar.gz"
  sha1 "8a4fc2440faa3050244e5a492fb6766899e0c0d7"
  head "git://repo.or.cz/dvtm.git"

  bottle do
    cellar :any
    sha1 "5f90807a984ea18940aa62b31fccf1d5360fd904" => :yosemite
    sha1 "0cc466200f2eb56604e6222055d3860dc66804e1" => :mavericks
    sha1 "55a10e62092fed633e9252d07134a7cad1df8217" => :mountain_lion
  end

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
