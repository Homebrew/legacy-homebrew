require 'formula'

class Synfigstudio < Formula
  homepage 'http://synfig.org'
  url 'http://downloads.sourceforge.net/project/synfig/releases/0.64.1/source/synfigstudio-0.64.1.tar.gz'
  sha1 '0ba926d567fbfb79ba84899a2fcd79e54e33d4a4'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'libsigc++'
  depends_on 'gtkmm'
  depends_on 'etl'
  depends_on 'synfig'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
