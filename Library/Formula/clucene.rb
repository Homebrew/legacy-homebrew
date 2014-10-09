require "formula"

class Clucene < Formula
  homepage "http://clucene.sourceforge.net"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha1 "76d6788e747e78abb5abf8eaad78d3342da5f2a4"

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
    sha1 "b68104eea0ce8f8bf1cd0d622260765ff3798bc3"
  end

  patch do
    url "https://trac.macports.org/export/126047/trunk/dports/devel/clucene/files/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha1 "960281967e6e958d64a51920fda8fbd73e4913d9"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
