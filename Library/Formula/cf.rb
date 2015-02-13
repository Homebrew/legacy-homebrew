class Cf < Formula
  homepage "http://ee.lbl.gov"
  url "ftp://ee.lbl.gov/cf-1.2.5.tar.gz"
  sha1 "0ef0b03c1ea7221d75dac0ce110fd677e1f0182a"

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
