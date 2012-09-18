require 'formula'

class GedaGaf < Formula
  homepage 'http://geda.seul.org'
  url 'http://geda.seul.org/release/v1.6/1.6.2/geda-gaf-1.6.2.tar.gz'
  sha1 '87c21b3b77eebc8eec1c16672d4b1ab418ccb80d'

  devel do
    url 'http://geda.seul.org/devel/v1.7/1.7.2/geda-gaf-1.7.2.tar.gz'
    sha1 '519f759211158a61689646e9963cb8c4bb5bb9a4'
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'guile'
  depends_on 'gawk'
  depends_on :x11

  # MacPorts fix for glib 2.32 includes
  # Needed for 1.6.2 and 1.7.x
  def patches
    {:p0 => [
      "https://trac.macports.org/export/92743/trunk/dports/science/geda-gaf/files/patch-glib-2.32.diff"
    ]}
  end

  def install
    # Help configure find libraries
    gettext = Formula.factory('gettext')

    system "./configure", "--prefix=#{prefix}",
                          "--with-gettext=#{gettext.prefix}",
                          "--disable-update-xdg-database"

    system "make"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end
