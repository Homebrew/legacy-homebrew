require 'formula'

class Wakeonlan < Formula
  url 'http://gsd.di.uminho.pt/jpo/software/wakeonlan/downloads/wakeonlan-0.41.tar.gz'
  homepage 'http://gsd.di.uminho.pt/jpo/software/wakeonlan/'
  md5 'd3143c5fe92d16196ac853b55dd421b5'

  def install
    system "perl", "Makefile.PL"
    system "make"
    # 'make install' tries to put stuff in /Library/Perl
    bin.install 'blib/script/wakeonlan'
    man1.install 'blib/man1/wakeonlan.1'
  end
end
