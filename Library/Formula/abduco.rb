require "formula"

class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.1.tar.gz"
  sha1 "063b66d8a9a83ecd5b9501afc86812a06ad79076"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any
    sha1 "dc3f05e32b87e67d3b9da26e199fb92de369794a" => :mavericks
    sha1 "1fe57b58b3cdac26a667f19ad25bf0c06dcbf1f0" => :mountain_lion
    sha1 "d7c559b7d1a696d8ca34934276f715461ee0ed33" => :lion
  end

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
