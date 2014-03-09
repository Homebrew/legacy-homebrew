require 'formula'

class Synfig < Formula
  homepage 'http://synfig.org'
  url 'https://downloads.sourceforge.net/project/synfig/releases/0.64.1/source/synfig-0.64.1.tar.gz'
  sha1 '19fe81f144100c3f5e14a1b88b26a9b659fee3b8'

  head 'git://synfig.git.sourceforge.net/gitroot/synfig/synfig'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'etl'
  depends_on 'libsigc++'
  depends_on 'libxml++'
  depends_on 'imagemagick'
  depends_on :libpng
  depends_on :freetype
  depends_on 'cairo'
  depends_on 'pango'
  depends_on 'boost'
  depends_on 'openexr'
  depends_on :libtool => :run

  def patches
    # Candidate upstream patch for Xcode 5
    # http://www.synfig.org/issues/thebuggenie/synfig/issues/504
    "http://www.synfig.org/issues/thebuggenie/files/show/79"
  end

  def install
    boost = Formula["boost"]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{boost.opt_prefix}"
    system "make install"
  end
end
