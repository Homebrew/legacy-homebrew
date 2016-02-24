class Txt2tags < Formula
  desc "Conversion tool to generating several file formats"
  homepage "http://txt2tags.org"
  url "https://txt2tags.googlecode.com/files/txt2tags-2.6.tgz"
  sha256 "601467d7860f3cfb3d48050707c6277ff3ceb22fa7be4f5bd968de540ac5b05c"

  bottle :unneeded

  def install
    bin.install "txt2tags"
    man1.install "doc/manpage.man" => "txt2tags.1"
  end

  test do
    (testpath/"test.txt").write ("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match %r{<H1>Title</H1>}, File.read("test.html")
  end
end
