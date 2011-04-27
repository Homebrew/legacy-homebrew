require 'formula'

class Highlight < Formula
  url 'http://www.andre-simon.de/zip/highlight-2.16.tar.bz2'
  homepage 'http://www.andre-simon.de/doku/highlight/en/highlight.html'
  sha1 'b5fed14bb1a973fe134dd2133766bb86fdc7494e'

  def install
    conf = etc+'highlight/'
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf}", "install"
  end
end
