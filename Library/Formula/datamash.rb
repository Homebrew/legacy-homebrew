require "formula"

class Datamash < Formula
  homepage "http://www.gnu.org/software/datamash"
  url "http://ftpmirror.gnu.org/datamash/datamash-1.0.6.tar.gz"
  sha1 "2423314727dfe1750a8f0c6dbc131458a6a67ca6"

  bottle do
    cellar :any
    sha1 "28231bb8c1782e8453d9c2575792d2ea300c29f3" => :mavericks
    sha1 "67f68d8ab48a76ce80d7c68b32345d9a9dfea2aa" => :mountain_lion
    sha1 "c28075f2c254bc61485b2b20a8d778082bb46f92" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = `seq 10 | '#{bin}/datamash' sum 1`
    assert $?.success?
    assert_equal "55\n", output
  end
end
