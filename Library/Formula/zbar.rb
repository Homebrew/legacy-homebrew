require 'formula'

class Zbar <Formula
  url 'http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2'
  homepage 'http://zbar.sourceforge.net'
  md5 '0fd61eb590ac1bab62a77913c8b086a5'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'imagemagick'
  depends_on 'ufraw'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-python=no", "--without-qt",  "--disable-video", "--without-gtk"
    system "make install"
  end
end
