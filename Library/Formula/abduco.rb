require "formula"

class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.1.tar.gz"
  sha1 "063b66d8a9a83ecd5b9501afc86812a06ad79076"
  head "git://repo.or.cz/abduco.git"

  # upstream fix for BSD strip -s behavior compared to GNU
  # safe to remove in abduco versions after 0.1
  patch do
    url "http://repo.or.cz/w/abduco.git/patch/940519"
    sha1 "45bd29721d0e52d6875a8e3e21c16792a5758be9"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    session = "0.1-homebrew-test-session"
    expected = "[?25h[999Habduco: #{session}: session terminated with exit status 0\n"
    output = `printf "" | #{bin}/abduco -e "" -c #{session} true &> /dev/null && printf "\n" | #{bin}/abduco -a #{session} 2>&1 | sed '$d' | tail -1 | sed 's/.$//'`
    assert_equal expected, output
  end
end
