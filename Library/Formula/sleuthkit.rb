require 'formula'

class Sleuthkit <Formula
  head 'http://svn.sleuthkit.org/repos/sleuthkit/trunk', :using => :svn
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.1.3/sleuthkit-3.1.3.tar.gz'
  homepage 'http://www.sleuthkit.org/'
  md5 'e1798bede2112ec4c5770151c3e32bfd'

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  def install
    if ARGV.build_head
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
