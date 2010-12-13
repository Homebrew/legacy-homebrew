require 'formula'

class Jpegoptim <Formula
  url 'http://www.kokkonen.net/tjko/src/jpegoptim-1.2.3.tar.gz'
  homepage 'http://www.kokkonen.net/tjko/projects.html'
  md5 '36afa60f8baac825935e215eb19e41e0'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
