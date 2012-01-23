require 'formula'

class Eet < Formula
  url 'http://download.enlightenment.org/releases/eet-1.4.1.tar.gz'
  homepage 'http://trac.enlightenment.org/e/wiki/Eet'
  md5 '88d126fce01dc1330a1e798d9063aba1'
  head 'http://svn.enlightenment.org/svn/e/trunk/eet/', :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'jpeg'
  depends_on 'lzlib'

  def install
    # hack to allow building with current trunk, will be made obsolete after 1.1
    # is released: http://comments.gmane.org/gmane.comp.window-managers.enlightenment.devel/30780
    inreplace 'configure.ac', 'm4_define([v_mic], [999])', 'm4_define([v_mic], [99])' if ARGV.build_head?
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
