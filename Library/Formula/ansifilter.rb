require "formula"

class Ansifilter < Formula
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-1.11.tar.gz"
  sha256 "bdbd6cda51be643e070c98139e79061ab3c2935c4b26c4a098bc64fa3328d1a3"

  bottle do
    cellar :any
    sha1 "e28d7cd8ef0c42040b216d9eb6087ddc90cba855" => :mavericks
    sha1 "6110cc501ebfe6a7d402b778880651314310ce3b" => :mountain_lion
    sha1 "2ab9271e360293e599926909da601e511c270152" => :lion
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
