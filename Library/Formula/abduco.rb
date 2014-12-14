require "formula"

class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.2.tar.gz"
  sha1 "e3a706b782fcb18fd70076ff3550bfdb4829b2ec"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any
    sha1 "dc3f05e32b87e67d3b9da26e199fb92de369794a" => :mavericks
    sha1 "1fe57b58b3cdac26a667f19ad25bf0c06dcbf1f0" => :mountain_lion
    sha1 "d7c559b7d1a696d8ca34934276f715461ee0ed33" => :lion
  end

  def install
    inreplace "config.mk", 'CFLAGS += -std=c99 -Os ${INCS} -DVERSION=\"${VERSION}\" -DNDEBUG -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700', 'CFLAGS += -std=c99 -Os ${INCS} -DVERSION=\"${VERSION}\" -DNDEBUG'
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    session = "homebrew-test-session"
    expected = "[?25h[999Habduco: #{session}: session terminated with exit status 0\n"
    output = `printf "" | #{bin}/abduco -e "" -c #{session} true &> /dev/null && printf "\n" | #{bin}/abduco -a #{session} 2>&1 | sed '$d' | tail -1 | sed 's/.$//'`
    assert_equal expected, output
  end
end
