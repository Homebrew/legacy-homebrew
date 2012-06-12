require 'formula'

class Synfig < Formula
  homepage 'http://synfig.org'
  url 'http://downloads.sourceforge.net/project/synfig/synfig/0.63.05/synfig-0.63.05.tar.gz'
  sha1 'd532b8dd37a7eed10ea5de6f5b2b2dd419648f2c'

  head 'git://synfig.git.sourceforge.net/gitroot/synfig/synfig'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'etl'
  depends_on 'libsigc++'
  depends_on 'libxml++'
  depends_on 'imagemagick'

  def install
    ENV.libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
