require 'formula'

class GedaGaf < Formula
  url 'http://geda.seul.org/release/v1.6/1.6.2/geda-gaf-1.6.2.tar.gz'
  homepage 'http://geda.seul.org'
  md5 '35ae86aebc174ec1fc03863fde4c843c'

  depends_on 'pkg-config' => :build
  depends_on 'guile'
  depends_on 'gtk+'
  depends_on 'gawk'
  depends_on 'gettext'

  def install
    # Help configure find libraries
    ENV.x11

    gettext = Formula.factory('gettext')

    args = ["--disable-update-xdg-database",
            "--prefix=#{prefix}",
            "--with-gettext=#{gettext.prefix}"]

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end
