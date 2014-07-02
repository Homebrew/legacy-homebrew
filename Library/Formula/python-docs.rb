require "formula"

class PythonDocs < Formula
  homepage "https://docs.python.org/2/"
  url "https://docs.python.org/2/archives/python-2.7.8-docs-html.tar.bz2"
  sha1 "125db6f107f47566e46b5c1745fec1e0dfaf95a0"

  def install
    doc.install Dir["*"]
    ohai "You may want to add the following url as bookmark in your browser:"
    ohai "  file://#{HOMEBREW_PREFIX}/share/doc/python-docs/index.html"
  end
end
