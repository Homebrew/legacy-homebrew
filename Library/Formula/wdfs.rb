require 'formula'

class Wdfs < Formula
  homepage 'http://noedler.de/projekte/wdfs/'
  url 'http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz'
  sha1 '71ae2e355d00bc1fbe7093b0a3b15ddc76a74516'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'neon'
  depends_on 'osxfuse'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/wdfs", "-v"
  end
end
