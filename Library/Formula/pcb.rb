require 'formula'

class Pcb < Formula
  url 'http://geda.seul.org/dist/pcb-20100929.tar.gz'
  homepage 'http://pcb.gpleda.org/'
  md5 '4c71f5d1c40ad65539957748b88eb863'

  depends_on 'gtk+'
  depends_on 'gd'
  depends_on 'gettext'
  depends_on 'd-bus'
  depends_on 'intltool'

  def install
    # Help configure find libraries
    ENV.x11
    ENV.gcc_4_2

    gettext = Formula.factory('gettext')

    args = ["--disable-update-desktop-database",
            "--disable-update-mime-database",
            "--prefix=#{prefix}",
            "--with-gettext=#{gettext.prefix}",
            "--enable-dbus"]

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end
