require "formula"

class Fossil < Formula
  homepage "http://www.fossil-scm.org/"
  head "fossil://http://www.fossil-scm.org/"
  url "http://www.fossil-scm.org/download/fossil-src-20140612172556.tar.gz"
  sha1 "173c3350ba39ecfee6e660f866b4f3104e351b33"
  version "1.29"

  bottle do
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
