require 'formula'

class Sleuthkit < Formula
  head 'http://svn.sleuthkit.org/repos/sleuthkit/trunk', :using => :svn
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.2.2/sleuthkit-3.2.2.tar.gz'
  homepage 'http://www.sleuthkit.org/'
  md5 'bc6244a086e4e35215b8e1a776f63c5c'

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  def install
    if ARGV.build_head?
      system "glibtoolize"
      system "aclocal"
      system "automake", "--add-missing", "--copy"
      system "autoconf"
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
