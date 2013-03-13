require 'formula'

class Doxygen < Formula
  homepage 'http://www.doxygen.org/'
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.3.1.src.tar.gz'
  mirror 'http://downloads.sourceforge.net/project/doxygen/rel-1.8.3.1/doxygen-1.8.3.1.src.tar.gz'
  sha1 '289fc809f44b8025d45279deefbaee7680efd88f'

  head 'https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk'

  option 'with-dot', 'Build with dot command support from Graphviz.'
  option 'with-doxywizard', 'Build GUI frontend with qt support.'

  depends_on 'graphviz' if build.include? 'with-dot'
  depends_on 'qt' if build.include? 'with-doxywizard'

  def install
    system "./configure", "--prefix", prefix
    # Per Macports:
    # https://trac.macports.org/browser/trunk/dports/textproc/doxygen/Portfile#L92
    inreplace %w[ libmd5/Makefile.libmd5
                  src/Makefile.libdoxycfg
                  tmake/lib/macosx-c++/tmake.conf
                  tmake/lib/macosx-intel-c++/tmake.conf
                  tmake/lib/macosx-uni-c++/tmake.conf ] do |s|
      # otherwise clang may use up large amounts of RAM while
      # processing localization files
      # gcc doesn't support the flag
      s.gsub! '-Wno-invalid-source-encoding', '' \
        unless ENV.compiler == :clang
      # makefiles hardcode both cc and c++
      s.gsub! /cc$/, ENV.cc
      s.gsub! /c\+\+$/, ENV.cxx
    end

    system "make"
    # MAN1DIR, relative to the given prefix
    system "make", "MAN1DIR=share/man/man1", "install"
  end
end
