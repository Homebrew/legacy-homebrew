require 'formula'

class Ctags < Formula
  homepage 'http://ctags.sourceforge.net/'
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  sha1 '482da1ecd182ab39bbdc09f2f02c9fba8cd20030'

  head 'https://ctags.svn.sourceforge.net/svnroot/ctags/trunk'

  depends_on :autoconf

  fails_with :llvm do
    build 2335
    cause "Resulting executable generates erroneous tag files"
  end

  def install
    # See https://trac.macports.org/changeset/93604
    ENV.O1
    if build.head?
      system "autoheader"
      system "autoconf"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make install"
  end
end
