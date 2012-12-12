require 'formula'

class Epstool < Formula
  homepage 'http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm'
  url 'http://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/epstool-3.08.tar.gz'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz'
  sha1 'dc495934f06d3ea8b3209e8b02ea96c66c34f614'

  def install
    system "make", "install",
                   "EPSTOOL_ROOT=#{prefix}",
                   "EPSTOOL_MANDIR=#{man}",
                   "CC=#{ENV.cc}"
  end
end
