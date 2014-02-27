require 'formula'

class Shivavg < Formula
  homepage 'http://sourceforge.net/projects/shivavg/'
  url 'https://downloads.sourceforge.net/project/shivavg/ShivaVG/0.2.1/ShivaVG-0.2.1.zip'
  sha1 'f018c9d525f6cc65703bd1310662aca68e04e5d3'

  depends_on :automake
  depends_on :autoconf
  depends_on :libtool

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-example-all=no"
    system "make", "install"
  end
end
