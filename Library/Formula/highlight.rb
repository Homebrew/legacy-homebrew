class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.25.tar.bz2"
  sha256 "d8a9b8989c8b4108de0a76ceb585a5777ab308a339a667a9b05ee3d059dade26"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "958ff535fb022cadf4dfb3e61d29eba062705370602687d23268433ae891a5b2" => :el_capitan
    sha256 "bf588faf45e0ffe20c78e6db486a9b5fd72e3b33c98e7987583fe56119dac304" => :yosemite
    sha256 "1057388a30be19440b6277171308e0d8f068a4a38290730aa56a4aaa81c44ee4" => :mavericks
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
