require 'formula'

class StoneSoup < Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.9.0/stone_soup-0.9.0.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 '8c5a5d44b18733076cc95925315107bc'

  # Keep empty folders for save games and such
  skip_clean :all

  def install
    ENV.x11
    Dir.chdir "source"
    system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "TILES=y", "install"
  end
end
