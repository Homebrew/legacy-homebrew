require 'formula'

class Stp < Formula
  head 'http://stp-fast-prover.svn.sourceforge.net/svnroot/stp-fast-prover/trunk/stp', :revision => '1134'
  homepage 'http://sites.google.com/site/stpfastprover/'

  def install
    system "./scripts/configure", "--with-prefix=#{prefix}"
    system "make install"
  end
end
