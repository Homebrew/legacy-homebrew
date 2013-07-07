require 'formula'

class MtDaapd < Formula
  homepage 'http://www.fireflymediaserver.org/'
  url 'http://downloads.sourceforge.net/project/mt-daapd/mt-daapd/0.2.4.2/mt-daapd-0.2.4.2.tar.gz'
  sha1 '5f1c04100b1d18a9cf6f03f879b5c3e9a7bd172f'

  depends_on 'gdbm'
  depends_on 'libid3tag'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
