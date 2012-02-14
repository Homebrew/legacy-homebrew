require 'formula'

class GnomeColorManager < Formula
  homepage ''
  url 'http://ftp.gnome.org/pub/GNOME/sources/gnome-color-manager/3.3/gnome-color-manager-3.3.5.tar.xz'
  md5 'fdd50f434b789f3153d3a13b640063a7'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gnome-doc-utils'

  def install
    ENV.append 'PKG_CONFIG_PATH', '/usr/local/share/pkgconfig', ':'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-man-pages",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test gnome-color-manager`. Remove this comment before submitting
    # your pull request!
    system "true"
  end
end
