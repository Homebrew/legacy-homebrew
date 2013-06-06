require 'formula'

class Wakeonlan < Formula
  homepage 'http://gsd.di.uminho.pt/jpo/software/wakeonlan/'
  url 'http://gsd.di.uminho.pt/jpo/software/wakeonlan/downloads/wakeonlan-0.41.tar.gz'
  sha1 '95ed4be631e291fc07a72d5625a1ee915b35f85f'

  def install
    system "perl", "Makefile.PL"
    system "make"
    # 'make install' tries to put stuff in /Library/Perl
    bin.install 'blib/script/wakeonlan'
    man1.install 'blib/man1/wakeonlan.1'
  end
end
