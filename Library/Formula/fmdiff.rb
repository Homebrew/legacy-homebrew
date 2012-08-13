require 'formula'

class Fmdiff < Formula
  homepage 'http://www.defraine.net/~brunod/fmdiff/'
  url 'http://bruno.defraine.net/fmdiff/fmscripts-20120813.tar.gz'
  sha1 'a5342820893f61b29e1060527cc722ef51574911'

  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/', :using => :svn

  def install
  	system "make"
  	system "make", "DESTDIR=#{prefix}/bin", "install"
  end
end
