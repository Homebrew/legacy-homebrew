class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.html"
  url "http://www.andre-simon.de/zip/highlight-3.24.tar.bz2"
  sha256 "4f921697de9db93fb54bb667e6245b2831c153fc00dfa592ec50e42d345679cd"

  head "svn://svn.code.sf.net/p/syntaxhighlight/code/highlight/"

  bottle do
    sha256 "3e0df3d12050c94269d8e4be68e411acd753f74e56eb0ccc6b7866e8f4d0a21d" => :el_capitan
    sha256 "a00e8653281375665d4a39ed9e4e1fdc30fb1d64f3d7f09992fb258e0de2859f" => :yosemite
    sha256 "7d5297d4b5978e9055ee552d73561d2441456c1a7b263107504e48d77150ecf4" => :mavericks
    sha256 "855e131bf67b5f67be9907cde35a69e40d16a8fa6b714a0e36e8da77475ef296" => :mountain_lion
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
