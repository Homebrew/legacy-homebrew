require 'formula'

class StoneSoup <Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.7.1/stone_soup-0.7.1.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 'e95e538264bbcf6db64cec920d669542'

  def install
    Dir.chdir "source"
    system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "install"
  end
end
