require "formula"

class Ansifilter < Formula
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-1.11.tar.gz"
  sha256 "bdbd6cda51be643e070c98139e79061ab3c2935c4b26c4a098bc64fa3328d1a3"

  bottle do
    cellar :any
    sha1 "0206b02f9a153af5ae065636d6a0d3b5909b0f30" => :yosemite
    sha1 "eaaeb1c8ad032d26afd990f426cc4b4da0dbd0ba" => :mavericks
    sha1 "a726df12fc5b88a027225db2e16b736328b38267" => :mountain_lion
  end

  def install
    # both steps required and with PREFIX, last checked v1.11
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end
