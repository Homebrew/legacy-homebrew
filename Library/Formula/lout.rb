require 'formula'

class Lout < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/lout/index.php'
  url 'ftp://ftp.cs.usyd.edu.au/jeff/lout/lout-3.38.tar.gz'
  sha1 '2c4aec500dc27a00298f8265b9249d74d97e5466'

  def install
    inreplace "makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "LOUTLIBDIR", lib
      s.change_make_var! "LOUTDOCDIR", doc
      s.change_make_var! "MANDIR", man1
    end
    bin.mkpath
    man1.mkpath
    (doc/'lout').mkpath
    system "make allinstall"
  end
end
