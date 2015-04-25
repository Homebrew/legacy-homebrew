class Highlight < Formula
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.22.tar.bz2"
  sha256 "4776ce4305e6f92d8a9faf5d0aeffd56f413ad57e55303e7a2a6357387ec056f"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

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
