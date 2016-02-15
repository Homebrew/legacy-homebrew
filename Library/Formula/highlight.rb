class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.27.tar.bz2"
  sha256 "9d0aa72d434fa22acde50ceafb165efcd03799335396b24b134a5632387cf7b0"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "44c3628be09894287d4a9043bc0ed537d2b1fa5e4b12c5ed6980fad3bed97872" => :el_capitan
    sha256 "972af95b13ba615ee7850103fce0ceea8c807e60ef5392f7815d0045a1eba0fb" => :yosemite
    sha256 "4395a99b800e387fdfd7779a7bd71fc5de67b6af1b0f439f01909daa720a8ca1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"examples/highlight_pipe.php"
  end
end
