class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.24.tar.bz2"
  sha256 "4f921697de9db93fb54bb667e6245b2831c153fc00dfa592ec50e42d345679cd"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "e2d0eb140cdaa45931dd32212621500e95a9db6a1a19cbcb539cb6010e74c5d3" => :el_capitan
    sha256 "a06afe91fe7f0129c739f569c4d6aba8f8d31e76f1f866fb33d4bc2d4b0a2f98" => :yosemite
    sha256 "445b07accae01939d4737b340cd90ce2731648de14aae6a5ec0b89fa6fee794b" => :mavericks
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
