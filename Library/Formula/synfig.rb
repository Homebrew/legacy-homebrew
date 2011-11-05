require 'formula'

class Synfig < Formula
  url 'https://downloads.sourceforge.net/project/synfig/synfig/0.62.02/synfig-0.62.02.tar.gz'
  homepage 'http://synfig.org'
  head 'git://synfig.git.sourceforge.net/gitroot/synfig/synfig', :using => :git
  md5 'e6af1aa9426cf629127d23edbd772f6d'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'etl'
  depends_on 'libsigc++'
  depends_on 'libxml++'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
