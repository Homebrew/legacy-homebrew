class Dvtm < Formula
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.14.tar.gz"
  sha1 "205a2165e70455309f7ed6a6f11b3072fb9b13c3"
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
    assert_match /^dvtm-#{version}/, result
  end
end
