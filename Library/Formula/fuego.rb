require 'formula'

class Fuego <Formula
  url 'http://downloads.sourceforge.net/project/fuego/fuego/0.4.1/fuego-0.4.1.tar.gz'
  homepage 'http://fuego.sourceforge.net/'
  md5 'f572114ca5894d9d65728b546e31b7bb'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
