require 'formula'

class Highlight < Formula
  url 'http://www.andre-simon.de/zip/highlight-3.6.tar.bz2'
  homepage 'http://www.andre-simon.de/doku/highlight/en/highlight.html'
  sha1 'ff3d5f5d17edfed4881d34ef847e63bf800a33e2'

  depends_on 'boost'
  depends_on 'lua'

  def install
    conf_dir = etc+'highlight/' # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end
end
