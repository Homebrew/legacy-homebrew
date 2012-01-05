require 'formula'

class Gtkpod < Formula
  url 'http://downloads.sourceforge.net/project/gtkpod/gtkpod/gtkpod-2.1.0/gtkpod-2.1.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgtkpod%2Ffiles%2Fgtkpod%2F&ts=1325620353&use_mirror=iweb'
  homepage 'http://gtkpod.org/wiki/Home'
  version '2.1.0'
  md5 '8e01f7cf2db1a421140eab561aee26d7'

  depends_on 'libgpod'
  depends_on 'gtk+' # 3.0

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
