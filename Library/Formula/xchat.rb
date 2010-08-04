require 'formula'

class Xchat <Formula
  url 'http://xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2'
  homepage 'http://xchat.org'
  md5 '6775c44f38e84d06c06c336b32c4a452'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-openssl",
                          "--disable-python",
                          "--disable-xlib",
                          "--disable-perl",
                          "--disable-plugin"
    system "make install"
    rm_rf share+"applications"
    rm_rf share+"pixmaps"
  end
end
