class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/google/trace-viewer"
  url "https://github.com/google/trace-viewer/archive/a4c4894801935627ff412c3cc6c3ddae96019cc5.zip"
  sha256 "b9fc71e6f1a36f91ca09c1ea26ae2c38e42d3183b6470e603d1db8b1ee6e8316"

  depends_on "Python"

  def install
    cp_r(buildpath, libexec)
    bin.install_symlink libexec/"trace2html"
  end

  test do
    touch "test.json"
    system "#{bin}/trace2html test.json"
    assert File.exist?("test.html")
  end
end
