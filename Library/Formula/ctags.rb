require 'formula'

class Ctags < Formula
  homepage 'http://ctags.sourceforge.net/'
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  sha1 '482da1ecd182ab39bbdc09f2f02c9fba8cd20030'

  head 'https://ctags.svn.sourceforge.net/svnroot/ctags/trunk'

  depends_on :autoconf => :build if build.head?

  def patches
    # fixes http://sourceforge.net/tracker/?func=detail&aid=3247256&group_id=6556&atid=106556
    { :p2 => "https://raw.github.com/gist/4010022/8d0697dc87a40e65011e2192439609c17578c5be/ctags.patch" }
  end

  def install
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
