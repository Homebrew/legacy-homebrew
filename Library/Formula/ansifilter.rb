class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-1.12.tar.bz2"
  sha256 "05f64cbc8440b44e8cfe26ae679074531997d14ecbbf595a9e03c0b489bf1cd1"

  bottle do
    cellar :any
    sha1 "0206b02f9a153af5ae065636d6a0d3b5909b0f30" => :yosemite
    sha1 "eaaeb1c8ad032d26afd990f426cc4b4da0dbd0ba" => :mavericks
    sha1 "a726df12fc5b88a027225db2e16b736328b38267" => :mountain_lion
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end
