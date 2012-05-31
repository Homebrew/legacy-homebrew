require 'formula'

class Synfig < Formula
  url 'http://downloads.sourceforge.net/project/synfig/synfig/0.63.03/synfig-0.63.03.tar.gz'
  homepage 'http://synfig.org'
  md5 '9bd77cd2fc2381adfbd50a7b9c1c6e7c'

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
