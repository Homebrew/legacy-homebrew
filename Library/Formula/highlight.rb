require 'formula'

class Highlight < Formula
  homepage 'http://www.andre-simon.de/doku/highlight/en/highlight.html'
  url 'http://www.andre-simon.de/zip/highlight-3.18.tar.bz2'
  sha1 '985d0a3c707e3251fe50ffff66e11a8563777202'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'lua'

  def install
    conf_dir = etc+'highlight/' # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end
end
