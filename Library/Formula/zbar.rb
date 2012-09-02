require 'formula'

class Zbar < Formula
  url 'http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2'
  homepage 'http://zbar.sourceforge.net'
  sha1 '273b47c26788faba4325baecc34063e27a012963'

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
