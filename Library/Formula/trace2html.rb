class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/google/trace-viewer"
  url "https://github.com/google/trace-viewer/archive/2015-06-23.tar.gz"
  sha256 "97ad0ca9c07a50c53a3d881b69b6b6f7424d6b0f4d9e9fb531c2d9273e413f19"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"trace2html"
  end

  test do
    touch "test.json"
    system "#{bin}/trace2html", "test.json"
    assert File.exist?("test.html")
  end
end
