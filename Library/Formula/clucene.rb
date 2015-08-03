class Clucene < Formula
  desc "C++ port of Lucene: high-performance, full-featured text search engine"
  homepage "http://clucene.sourceforge.net"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha256 "ddfdc433dd8ad31b5c5819cc4404a8d2127472a3b720d3e744e8c51d79732eab"

  bottle do
    cellar :any
    sha1 "80b58c05e8acc9b2848a57da7e052bf1a15812d9" => :mavericks
    sha1 "ba66e4b9422e8ad12b16c19589fde50198c5c700" => :mountain_lion
    sha1 "0564c414eca5a3d65eb8a217c03c114ffba1641e" => :lion
  end

  head "git://clucene.git.sourceforge.net/gitroot/clucene/clucene"

  depends_on "cmake" => :build

  # Portability fixes for 10.9+
  # Upstream ticket: http://sourceforge.net/p/clucene/bugs/219/
  patch do
    url "https://trac.macports.org/export/126047/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-LuceneThreads.h.diff"
    sha256 "42cb23fa6bd66ca8ea1d83a57a650f71e0ad3d827f5d74837b70f7f72b03b490"
  end

  patch do
    url "https://trac.macports.org/export/126047/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha256 "b7dc735f431df409aac63dcfda9737726999eed4fdae494e9cbc1d3309e196ad"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
