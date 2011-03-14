require 'formula'

class Epstool < Formula
  url 'http://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/epstool-3.08.tar.gz'
  homepage 'http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm'
  md5 '465a57a598dbef411f4ecbfbd7d4c8d7'

  def install
    inreplace 'makefile' do |s|
      s.change_make_var! "EPSTOOL_ROOT", prefix
      s.change_make_var! "EPSTOOL_MANDIR", man
    end
    system "make install"
  end
end
