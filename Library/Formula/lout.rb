require 'formula'

class Lout < Formula
  url 'ftp://ftp.cs.usyd.edu.au/jeff/lout/lout-3.38.tar.gz'
  homepage 'http://sourceforge.net/apps/mediawiki/lout/index.php'
  md5 '388ed456cfcb493ca706677688ec5dde'

  def install
    inreplace "makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "LOUTLIBDIR", lib
      s.change_make_var! "LOUTDOCDIR", doc
      s.change_make_var! "MANDIR", man1
    end
    bin.mkpath
    man1.mkpath
    (doc + 'lout').mkpath
    system "make allinstall"
  end
end
