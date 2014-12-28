require "formula"

class Fossil < Formula
  homepage "http://www.fossil-scm.org/"
  head "http://www.fossil-scm.org/", :using => :fossil
  url "http://www.fossil-scm.org/download/fossil-src-20140612172556.tar.gz"
  sha1 "173c3350ba39ecfee6e660f866b4f3104e351b33"
  version "1.29"

  bottle do
    cellar :any
    sha1 "977cde0938a0b751938aaac28cab1fe7ef479e9b" => :yosemite
    sha1 "f45d99ad80bdda2852a8dcb9e1292b5117d0ae56" => :mavericks
    sha1 "b00e434097adba303767426916654da1f17d7f39" => :mountain_lion
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"

  def install
    args = []
    args << "--json" if build.with? "json"
    args << "--with-tcl" if build.with? "tcl"

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end
end
