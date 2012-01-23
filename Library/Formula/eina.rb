require 'formula'

class Eina < Formula
  url 'http://download.enlightenment.org/releases/eina-1.0.1.tar.gz'
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  md5 'd302a5b981d8e140e64d2943c5f41bdc'
  head 'http://svn.enlightenment.org/svn/e/trunk/eina/', :using => :svn

  depends_on 'pkg-config' => :build

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
