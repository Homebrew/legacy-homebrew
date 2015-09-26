class Clucene < Formula
  desc "C++ port of Lucene: high-performance, full-featured text search engine"
  homepage "http://clucene.sourceforge.net"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha256 "ddfdc433dd8ad31b5c5819cc4404a8d2127472a3b720d3e744e8c51d79732eab"
  head "git://clucene.git.sourceforge.net/gitroot/clucene/clucene"

  bottle do
    cellar :any
    revision 1
    sha256 "182db4f73e058e9d28b77cbbd642c40ecc403fbf1d9dc8357387b2c54dba8d1e" => :yosemite
    sha256 "f85cdb67e53bc6eb380ae1bd8e087b42faca7c65f665f9719209adfa8aaa7b31" => :mavericks
    sha256 "97f955d2b9fa3ab41f65d9871f82a357cad400237cbaf553d585bae62207d51f" => :mountain_lion
  end

  depends_on "cmake" => :build

  # Portability fixes for 10.9+
  # Upstream ticket: http://sourceforge.net/p/clucene/bugs/219/
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/46d9672f7/Homebrew_Resources/MacPorts_Import/clucene/r126047/patch-src-shared-CLucene-LuceneThreads.h.diff"
    mirror "https://trac.macports.org/export/126047/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-LuceneThreads.h.diff"
    sha256 "42cb23fa6bd66ca8ea1d83a57a650f71e0ad3d827f5d74837b70f7f72b03b490"
  end

  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/46d9672f7/Homebrew_Resources/MacPorts_Import/clucene/r126047/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    mirror "https://trac.macports.org/export/126047/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha256 "b7dc735f431df409aac63dcfda9737726999eed4fdae494e9cbc1d3309e196ad"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
