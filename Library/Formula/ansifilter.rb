require 'formula'

class Ansifilter < Formula
  homepage 'http://www.andre-simon.de/doku/ansifilter/ansifilter.html'
  url 'http://www.andre-simon.de/zip/ansifilter-1.8.tar.gz'
  sha1 '805bc0227c5972a971a82d3db749fb2431c107c1'

  def install
    # both steps required and with PREFIX, last checked v1.7
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    output = `#{bin}/ansifilter #{path}`.strip
    assert_equal "foo", output
    assert_equal 0, $?.exitstatus
  end
end
