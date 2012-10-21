require 'formula'

class Velvet < Formula
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.08.tgz'
  sha1 'cef486759fa577d86ff67d70898ff330f5d0403c'

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
