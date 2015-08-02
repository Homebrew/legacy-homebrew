class Cf < Formula
  desc "Filter to replace numeric timestamps with a formated date time"
  homepage "http://ee.lbl.gov"
  url "ftp://ee.lbl.gov/cf-1.2.5.tar.gz"
  sha1 "0ef0b03c1ea7221d75dac0ce110fd677e1f0182a"

  bottle do
    cellar :any
    sha1 "524e3b5a4a669e4f479eac18fba9bb1876dd12ae" => :yosemite
    sha1 "991944ac26d1e11fe4592b6006a7fd247b5df4ce" => :mavericks
    sha1 "16f6118785e9110d2bf1fc187285965f7797389d" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match /Jan 20 00:35:44/, `echo 1074558944 | #{bin}/cf -u`
  end
end
