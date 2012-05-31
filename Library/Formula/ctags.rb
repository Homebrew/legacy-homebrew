require 'formula'

class Ctags < Formula
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  homepage 'http://ctags.sourceforge.net/'
  md5 'c00f82ecdcc357434731913e5b48630d'

  head 'https://ctags.svn.sourceforge.net/svnroot/ctags/trunk'

  depends_on 'autoconf' => :build if MacOS.xcode_version.to_f >= 4.3

  fails_with :llvm do
    build 2335
    cause "Resulting executable generates erroneous tag files"
  end

  def install
    if ARGV.build_head?
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
