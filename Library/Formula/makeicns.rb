class Makeicns < Formula
  desc "Create icns files from the command-line"
  homepage "https://bitbucket.org/mkae/makeicns"
  url "https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.10a.tar.bz2"
  sha256 "10e44b8d84cb33ed8d92b9c2cfa42f46514586d2ec11ae9832683b69996ddeb8"
  head "https://bitbucket.org/mkae/makeicns", :using => :hg

  patch :p0 do
    url "https://trac.macports.org/export/114372/trunk/dports/graphics/makeicns/files/patch-IconFamily.m.diff"
    sha256 "f5ddbf6a688d6f153cf6fc2e15e75309adaf61677ab423cb67351e4fbb26066e"
  end

  def install
    system "make"
    bin.install "makeicns"
  end
end
