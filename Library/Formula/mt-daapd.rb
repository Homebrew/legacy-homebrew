require 'formula'

class MtDaapd < Formula
  url 'http://downloads.sourceforge.net/project/mt-daapd/mt-daapd/0.2.4.2/mt-daapd-0.2.4.2.tar.gz'
  homepage 'http://www.fireflymediaserver.org/'
  sha1 '5f1c04100b1d18a9cf6f03f879b5c3e9a7bd172f'

  depends_on 'gdbm'
  depends_on 'libid3tag'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
