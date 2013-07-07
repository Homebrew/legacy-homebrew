require 'formula'

class Le < Formula
  homepage 'http://freecode.com/projects/leeditor'
  url 'http://ftp.yar.ru/pub/source/le/le-1.14.6.tar.xz'
  sha1 '8f2088c95d2707c464edc122543414af287e0fdb'

  depends_on 'xz' => :build

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
