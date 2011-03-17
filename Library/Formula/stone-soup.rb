require 'formula'

class StoneSoup < Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.7.2/stone_soup-0.7.2.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 'ffb54c88d280f036a3819cba23bc4489'

  def install
    Dir.chdir "source"
    system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "install"
  end
end
