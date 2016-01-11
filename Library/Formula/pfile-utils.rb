class PfileUtils < Formula
  desc "Collection of utilities for manipulating PFiles (ICSI feature file)"
  homepage "http://www1.icsi.berkeley.edu/Speech/qn.html"

  url "https://github.com/Marvin182/pfile-utilities/archive/v0.51.tar.gz"
  sha256 "151bb83af1c06a7168908d8440ebb15f880de360d7f292f41716fa84b520301a"
  head "https://github.com/Marvin182/pfile-utilities.git"

  depends_on "quicknet"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
