require 'formula'

class AptDater < Formula
  url 'http://downloads.sourceforge.net/project/apt-dater/apt-dater/0.8.6/apt-dater-0.8.6.tar.gz'
  homepage 'http://www.ibh.de/apt-dater/'
  md5 '1f1b92403b9afb74032254ed47e7bce3'

   depends_on 'popt'
   depends_on 'glib'
   depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    # Make stuff compile and on Mac OS X
    "https://raw.github.com/gist/1361591/mac_os_x.patch"
  end

  def test
    system "apt-dater"
  end
end
