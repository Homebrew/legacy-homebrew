require 'formula'

class Libgsf <Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.16.tar.bz2'
  homepage 'http://directory.fsf.org/project/libgsf/'
  md5 '8478d83fda0b6e57f36550c11a693ee1'

  depends_on 'gettext'

  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      ]

    system "./configure", *configure_args
    system "make install"
  end
end
