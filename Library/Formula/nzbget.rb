require 'formula'

class Nzbget < Formula
  url 'http://downloads.sourceforge.net/project/nzbget/nzbget-stable/0.7.0/nzbget-0.7.0.tar.gz'
  homepage 'http://sourceforge.net/projects/nzbget/'
  md5 '27971846aba75f5e312d80dce7edbc5d'
  head 'https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk', :using => :svn

  # Also depends on libxml2 but the one in OS X is fine
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'libpar2'
  depends_on 'gnutls'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
