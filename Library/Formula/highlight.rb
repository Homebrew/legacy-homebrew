class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.26.tar.bz2"
  sha256 "b3c93b49b3a0dec93a3b9ce6422f11f4eca44b572878e549e89f80e0c86ef1f4"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "81f6d8f62984b80c247050f87e4fc657cfd717e80fd9706c3b836d562b6ffdc7" => :el_capitan
    sha256 "d4c1fd1c8930626bd0af285317f10489120537aabee028e02092ae7345c926b0" => :yosemite
    sha256 "0ebefcb90b66f26f650afdc6e65f7f5af0f5a9a8e9595ef136ce00ce54094984" => :mavericks
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
