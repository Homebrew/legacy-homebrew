require 'formula'

class Wakeonlan < Formula
  url 'http://gsd.di.uminho.pt/jpo/software/wakeonlan/downloads/wakeonlan-0.41.tar.gz'
  homepage 'http://gsd.di.uminho.pt/jpo/software/wakeonlan/'
  md5 'd3143c5fe92d16196ac853b55dd421b5'

  def install
    system "perl", "Makefile.PL"
    # Make sure script and manual get installed in Cellar properly
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLSITESCRIPT", bin
      s.change_make_var! "INSTALLSITEMAN1DIR", man1
    end
    system "make"
    system "make install"
  end
end
