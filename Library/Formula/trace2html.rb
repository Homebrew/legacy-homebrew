class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/google/trace-viewer"
  url "https://github.com/google/trace-viewer/archive/a4c4894801935627ff412c3cc6c3ddae96019cc5.tar.gz"
  sha256 "40bf1613e23c0f483536667d3ab584889c50219768414f0086150b3c364269c3"

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
