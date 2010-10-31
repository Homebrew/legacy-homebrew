require 'formula'

class Gerbv <Formula
  url 'http://downloads.sourceforge.net/project/gerbv/gerbv/gerbv-2.4.0/gerbv-2.4.0.tar.gz'
  homepage 'http://gerbv.gpleda.org/'
  md5 '56431417df2d246db87e225783097d75'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'cairo' if MACOS_VERSION < 10.6

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-desktop-database"
    system "make install"
  end

  def caveats
    "Note: gerbv is an X11 application."
  end
end
