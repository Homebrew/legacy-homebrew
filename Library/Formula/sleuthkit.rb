require 'formula'

class Sleuthkit <Formula
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/3.1.3/sleuthkit-3.1.3.tar.gz'
  homepage 'http://www.sleuthkit.org/'
  md5 'e1798bede2112ec4c5770151c3e32bfd'

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
