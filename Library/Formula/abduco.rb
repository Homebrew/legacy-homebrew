require "formula"

class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.1.tar.gz"
  sha1 "063b66d8a9a83ecd5b9501afc86812a06ad79076"
  head "git://repo.or.cz/abduco.git"

  def install
    inreplace "Makefile", "strip -s", "strip"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
