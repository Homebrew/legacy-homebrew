require 'formula'

class Ekhtml < Formula
  homepage 'http://ekhtml.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ekhtml/ekhtml/0.3.2/ekhtml-0.3.2.tar.gz'
  sha1 'd4e6c25964f7e110073f646950dc307e84d61f1b'

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
