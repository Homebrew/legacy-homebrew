require 'formula'

class Cpulimit < Formula
  head 'https://cpulimit.svn.sourceforge.net/svnroot/cpulimit/trunk', :using=> :svn
  homepage 'http://cpulimit.sourceforge.net/'

  def install
    system "make"
    bin.install ['cpulimit']
  end

  def test
    system "cpulimit -l 50 ls"
  end
end
