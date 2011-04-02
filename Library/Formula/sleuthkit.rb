require 'formula'

class Sleuthkit < Formula
  head 'http://svn.sleuthkit.org/repos/sleuthkit/trunk', :using => :svn
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.2.1/sleuthkit-3.2.1.tar.gz'
  homepage 'http://www.sleuthkit.org/'
  md5 'd873361cb5ef29f02c7107f9aec39b4f'

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
