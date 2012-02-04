require 'formula'

class Velvet < Formula
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.03.tgz'
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  md5 'ed1eaea940eff649bc8031f2cc7b78b5'

  head 'https://github.com/dzerbino/velvet.git'

  def install
    inreplace 'Makefile' do |s|
      # recommended in Makefile for compiling on Mac OS X
      s.change_make_var! "CFLAGS", "-Wall -m64"
    end
    system "make velveth velvetg OPENMP=1 MAXKMERLENGTH=1 LONGSEQUENCES=1"
    bin.install ['velveth', 'velvetg']
  end
end
