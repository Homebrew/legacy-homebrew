require 'formula'

class Icmake < Formula
  homepage 'http://icmake.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/icmake/icmake/7.16.00/icmake_7.16.00.orig.tar.gz'
  sha1 '8e175538dabc40afbb933202166bfdffd5f675c2'
  head 'https://icmake.svn.sourceforge.net/svnroot/icmake/trunk/icmake'

  def patches
    [
      # Fix sed syntax
      "https://gist.github.com/ColinHebert/1377434/raw/2b9d07272210fdcdd1277abd64fb5d475a652086/conversions.diff",
      # Removes redundant __STDC_VERSION__ from lexer.c
      "https://gist.github.com/ColinHebert/1377507/raw/545a60cb39105c80d97e543dc77e00ab7ecbb5ff/lexer.c.diff",
      # Fix Installer
       "https://gist.github.com/ColinHebert/1377533/raw/c7cb3f768deafa8c2e393bed1f5d4acd42edc7bd/icm_install.diff",
    ]
  end

  def install
    (buildpath/"INSTALL.im").atomic_write <<-EOS.undent
      #define BINDIR      "#{bin}"
      #define SKELDIR     "#{share}/icmake"
      #define MANDIR      "#{man}"
      #define LIBDIR      "#{libexec}"
      #define CONFDIR     "#{etc}/icmake"
      #define DOCDIR      "#{doc}"
      #define DOCDOCDIR   "#{doc}"
    EOS

    system "./icm_bootstrap", "/"
    rm_r "tmp/#{bin}/icmake.dSYM"
    rm_r "tmp/#{bin}/icmun.dSYM"
    rm_r "tmp/#{libexec}/icm-comp.dSYM"
    rm_r "tmp/#{libexec}/icm-pp.dSYM"
    system "./icm_install", "strip", "all"
  end
end
