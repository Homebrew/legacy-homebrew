require 'formula'

class Embryo < Formula
  url 'http://download.enlightenment.org/releases/embryo-1.0.0.tar.gz'
  homepage 'http://trac.enlightenment.org/e/wiki/Embryo'
  md5 '2d6269c931656d5714197e508b144f18'
  head 'http://svn.enlightenment.org/svn/e/trunk/embryo/', :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'eina'

  def install
    # hack to allow building with current trunk, will be made obsolete after 1.1
    # is released: http://comments.gmane.org/gmane.comp.window-managers.enlightenment.devel/30780
    inreplace 'configure.ac', 'm4_define([v_mic], [999])', 'm4_define([v_mic], [99])' if ARGV.build_head?
    inreplace 'configure.ac', 'eina >= 1.0.999', 'eina >= 1.0.99' if ARGV.build_head?
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
