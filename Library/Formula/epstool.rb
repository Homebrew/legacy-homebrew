require 'formula'

class Epstool < Formula
  homepage 'http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm'
  url 'http://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/epstool-3.08.tar.gz'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz'
  md5 '465a57a598dbef411f4ecbfbd7d4c8d7'

  def install
    system "make", "install",
                   "EPSTOOL_ROOT=#{prefix}",
                   "EPSTOOL_MANDIR=#{man}",
                   "CC=#{ENV.cc}"
  end
end
