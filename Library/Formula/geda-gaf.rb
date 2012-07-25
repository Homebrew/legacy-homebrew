require 'formula'

class GedaGaf < Formula
  homepage 'http://geda.seul.org'
  url 'http://geda.seul.org/release/v1.6/1.6.2/geda-gaf-1.6.2.tar.gz'
  md5 '35ae86aebc174ec1fc03863fde4c843c'

  devel do
    url 'http://geda.seul.org/devel/v1.7/1.7.2/geda-gaf-1.7.2.tar.gz'
    md5 'ccfe334e333d6ed14ace22a43c2cdc7c'
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
    {:p0 => ["https://trac.macports.org/export/92743/trunk/dports/science/geda-gaf/files/patch-glib-2.32.diff"]}
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
