require 'formula'

class Velvet < Formula
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.07.tgz'
  sha1 '3431a49e7c57cc4db836fc3b997d61008d2e90f4'

  head 'https://github.com/dzerbino/velvet.git'

  def install
    inreplace 'Makefile' do |s|
      # recommended in Makefile for compiling on Mac OS X
      s.change_make_var! "CFLAGS", "-Wall -m64"
    end
    system "make velveth velvetg OPENMP=1 MAXKMERLENGTH=31 LONGSEQUENCES=1"
    bin.install 'velveth', 'velvetg'
  end
end
