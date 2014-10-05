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
end
