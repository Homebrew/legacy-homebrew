require 'formula'

class MtDaapd < Formula
  url 'http://downloads.sourceforge.net/project/mt-daapd/mt-daapd/0.2.4.2/mt-daapd-0.2.4.2.tar.gz'
  homepage 'http://www.fireflymediaserver.org/'
  md5 '67bef9fb14d487693b0dfb792c3f1b05'

  depends_on 'gdbm'
  depends_on 'libid3tag'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
