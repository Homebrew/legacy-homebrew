require "formula"

class Datamash < Formula
  homepage "http://www.gnu.org/software/datamash"
  url "http://ftpmirror.gnu.org/datamash/datamash-1.0.6.tar.gz"
  sha1 "2423314727dfe1750a8f0c6dbc131458a6a67ca6"

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
