require "formula"

class Astyle < Formula
  homepage "http://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%202.04/astyle_2.04_macosx.tar.gz"
  sha1 "2aa956c4521a1163da6a8be741786fd89c1f39a7"
  head "svn://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any
    sha1 "9228d8c5a0d97b26c6df18af9d1df5148edb1cd7" => :yosemite
    sha1 "cd2c3c120969f037dbf7e9fd20bb764b7bf2c7b1" => :mavericks
    sha1 "c4b8fb8f1d50e067c3c671d1522f5745cf69b94c" => :mountain_lion
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
