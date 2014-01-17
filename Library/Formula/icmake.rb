require 'formula'

class Icmake < Formula
  url 'http://downloads.sourceforge.net/project/icmake/icmake/7.16.00/icmake_7.16.00.orig.tar.gz'
  head 'https://icmake.svn.sourceforge.net/svnroot/icmake/trunk/icmake', :using => :svn
  homepage 'http://icmake.sourceforge.net/'
  sha1 '8e175538dabc40afbb933202166bfdffd5f675c2'
  version "7.16"
  
  def patches
    p = []
    # Fix Icmake's grep usage (with BSD sed) 
    p << "https://gist.github.com/ColinHebert/1377434/raw"
    # Fix Lexer
    p << "https://gist.github.com/ColinHebert/1377507/raw"
    # Fix Installer
    p << "https://gist.github.com/ColinHebert/1377533/raw"

    return p
  end

  def install
    # Write config file used during build process
    File.open('INSTALL.im', "w") {|file| file.puts <<-EOS.undent
      #define BINDIR      "#{bin}"
      #define SKELDIR     "#{share}"
      #define MANDIR      "#{man}"
      #define LIBDIR      "#{lib}"
      #define CONFDIR     "#{etc + "icmake"}"
      #define DOCDIR      "#{doc}"
      #define DOCDOCDIR   "#{doc.dirname() + "icmake-doc"}"
      EOS
    }

    system "./icm_bootstrap /"
    system "./icm_install all"
  end
end