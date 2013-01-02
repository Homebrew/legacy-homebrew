require 'formula'

class Pms < Formula
  url 'https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2'
  homepage 'http://pms.sourceforge.net'
  sha1 '344a1d211d752e32d32f42a3ad0ea513fcc42f81'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
