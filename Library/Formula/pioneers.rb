require 'formula'

class Pioneers < Formula
  url 'https://downloads.sourceforge.net/project/pio/Source/pioneers-0.12.5.tar.gz'
  homepage 'http://pio.sourceforge.net/'
  md5 'fd0c25382e7ebea0709c9464395739a2'

  depends_on 'intltool' # for NLS
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'librsvg' # svg images for gdk-pixbuf

  def install
    # fix usage of echo options not supported by sh
    inreplace "Makefile.in", /\becho/, "/bin/echo"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
