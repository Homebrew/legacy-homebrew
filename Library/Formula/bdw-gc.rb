require 'formula'

class BdwGc < Formula
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2alpha6.tar.gz'
  version '7.2alpha6'
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  head 'cvs://:pserver:anonymous@bdwgc.cvs.sourceforge.net:/cvsroot/bdwgc:bdwgc', :using => :cvs
  md5 '319d0b18cc4eb735c8038ece9df055e4'

  fails_with_llvm "LLVM gives an unsupported inline asm error" unless ARGV.build_head?

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
