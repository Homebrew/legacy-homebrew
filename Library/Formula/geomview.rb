require 'formula'

class Geomview <Formula
  url 'http://sourceforge.net/projects/geomview/files/geomview/1.9.4/geomview-1.9.4.tar.gz'
  homepage 'http://www.geomview.org'
  md5 '29c7e6d678af7b9968980f92954419bb'

  depends_on 'lesstif'

  def install
    ENV["CFLAGS"] = "-I/usr/X11/include"
    ENV["LDFLAGS"] = "-L/usr/X11/lib"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
